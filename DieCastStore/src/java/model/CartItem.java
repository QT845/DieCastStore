/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class CartItem {
    private String itemType; 
    private String itemId;
    private String itemName;
    private double unitPrice;
    private int quantity;
    private boolean selected;
    
    public CartItem(){
        this.selected = false;
    }
    
    public CartItem(String itemType, String itemId, String itemName, double unitPrice, int quantity){
        this.itemType = itemType;
        this.itemId = itemId;
        this.itemName = itemName;
        this.unitPrice = unitPrice; 
        this.quantity = quantity;
        this.selected = false;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }
    
    public double getSubTotal() {
        return unitPrice * quantity;
    }
}
