/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.BrandModel;
import model.ModelCar;
import utils.DBUtils;

/**
 *
 * @author hqthi
 */
public class ModelCarDAO implements IDAO<ModelCar, String> {

    private static final String GET_ALL = "SELECT * FROM modelCar";
    private static final String GET_BY_ID = "SELECT * FROM modelCar WHERE modelId = ?";
    private static final String GET_BY_NAME = "SELECT * FROM modelCar WHERE modelName like ?";
    private static final String CREATE = "INSERT INTO modelCar(modelId, modelName, scaleId, brandId, price, description, quantity) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE modelCar SET modelName = ?, scaleId = ?, brandId = ?, price = ?, description = ?, quantity = ? WHERE modelId = ?";
    private static final String DELETE = "DELETE FROM modelCar WHERE modelId = ?";
    private static final String MAX = "SELECT MAX(modelId) FROM modelCar WHERE modelId LIKE ?";
    private static final String COUNT = "SELECT COUNT(*) FROM modelCar";

    private static final Map<String, String> BRAND_PREFIX = new HashMap<>();

    static {
        BRAND_PREFIX.put("MiniGT", "MGT");
        BRAND_PREFIX.put("Hot Wheels", "HW");
        BRAND_PREFIX.put("Bburago", "BBR");
        BRAND_PREFIX.put("Maisto", "MST");
        BRAND_PREFIX.put("Tomica", "TMC");
        BRAND_PREFIX.put("AutoArt", "AAT");
        BRAND_PREFIX.put("GreenLight", "GL");
        BRAND_PREFIX.put("Kyosho", "KYO");
        BRAND_PREFIX.put("Matchbox", "MTB");
        BRAND_PREFIX.put("Welly", "WLY");
    }

    private BrandDAO brand;

    public ModelCarDAO() {
        this.brand = new BrandDAO();
    }

    public ModelCarDAO(BrandDAO brandDAO) {
        this.brand = brandDAO;
    }

    @Override
    public boolean create(ModelCar entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            BrandModel brandEntity = brand.getById(entity.getBrandId());
            entity.setModelId(generateModelID(brandEntity.getBrandName()));
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, entity.getModelId());
            st.setString(2, entity.getModelName());
            st.setInt(3, entity.getScaleId());
            st.setInt(4, entity.getBrandId());
            st.setDouble(5, entity.getPrice());
            st.setString(6, entity.getDescription());
            st.setInt(7, entity.getQuantity());

            return st.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean update(ModelCar entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, entity.getModelName());
            st.setInt(2, entity.getScaleId());
            st.setInt(3, entity.getBrandId());
            st.setDouble(4, entity.getPrice());
            st.setString(5, entity.getDescription());
            st.setInt(6, entity.getQuantity());
            st.setString(7, entity.getModelId());

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean delete(String id) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(DELETE);
            st.setString(1, id);

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public ModelCar getById(String id) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ID);
            st.setString(1, id);
            rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        return null;
    }
    
    public List<ModelCar> getByModelName(String modelName) {
        List<ModelCar> car = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_NAME);
            st.setString(1, "%"+modelName+"%");
            rs = st.executeQuery();
            while (rs.next()) {
                car.add(mapResultSet(rs));
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            closeResources(c, st, rs);
        }
        return car;
    }

    @Override
    public List<ModelCar> getAll() {
        List<ModelCar> car = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();
            while (rs.next()) {
                car.add(mapResultSet(rs));
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        return car;
    }

    private ModelCar mapResultSet(ResultSet rs) throws SQLException {
        ModelCar car = new ModelCar();
        car.setModelId(rs.getString("modelId"));
        car.setModelName(rs.getString("modelName"));
        car.setScaleId(rs.getInt("scaleId"));
        car.setBrandId(rs.getInt("brandId"));
        car.setPrice(rs.getDouble("price"));
        car.setDescription(rs.getString("description"));
        car.setQuantity(rs.getInt("quantity"));
        return car;
    }

    private String generateModelID(String brandName) {
        String prefix = BRAND_PREFIX.get(brandName);
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(MAX);
            st.setString(1, prefix + "%");
            rs = st.executeQuery();
            int nextNum = 1;
            if (rs.next() && rs.getString(1) != null) {
                String maxId = rs.getString(1);
                int currentNum = Integer.parseInt(maxId.substring(prefix.length()));
                nextNum = currentNum + 1;
            }
            return String.format("%s%03d", prefix, nextNum);
        } catch (Exception e) {
            e.printStackTrace();
            return prefix + "001";
        } finally {
            closeResources(c, st, rs);
        }
    }

    private void closeResources(Connection c, PreparedStatement st, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (st != null) {
                st.close();
            }
            if (c != null) {
                c.close();
            }
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
