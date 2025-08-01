﻿USE [master]
GO
DROP DATABASE DieCastStore
GO

CREATE DATABASE DieCastStore 
GO

USE DieCastStore
GO
CREATE TABLE customer (
    customerId VARCHAR(50) PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
	phone VARCHAR(20),
    address VARCHAR(500)
)

CREATE TABLE customerAccount (
    userName VARCHAR(50) PRIMARY KEY,
    customerId VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role INT DEFAULT 2,
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
)

CREATE TABLE brandModel (
    brandId INT IDENTITY(1,1) PRIMARY KEY,
    brandName VARCHAR(100) NOT NULL
)

CREATE TABLE scaleModel (
    scaleId INT IDENTITY(1,1) PRIMARY KEY,
    scaleLabel VARCHAR(50) NOT NULL
)

CREATE TABLE modelCar (
    modelId VARCHAR(50) PRIMARY KEY,
    modelName VARCHAR(100) NOT NULL,
    scaleId INT NOT NULL,
    brandId INT NOT NULL,
    price FLOAT NOT NULL,
    description TEXT,
    quantity INT,
    FOREIGN KEY (scaleId) REFERENCES scaleModel(scaleId),
    FOREIGN KEY (brandId) REFERENCES brandModel(brandId)
)

CREATE TABLE imageModel (
    imageId VARCHAR(50) PRIMARY KEY,
    modelId VARCHAR(50) NOT NULL,
    imageUrl VARCHAR(500) NOT NULL,
    caption VARCHAR(255),
    FOREIGN KEY (modelId) REFERENCES modelCar(modelId) ON DELETE CASCADE
)

CREATE TABLE accessory (
    accessoryId VARCHAR(50) PRIMARY KEY,
    accessoryName VARCHAR(100) NOT NULL,
    detail TEXT,
    price FLOAT NOT NULL,
    quantity INT,
	imageUrl VARCHAR(500)
)
CREATE TABLE orders (
    orderId VARCHAR(50) PRIMARY KEY,
    customerId VARCHAR(50) NOT NULL,
    orderDate DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, CONFIRMED, DELIVERED, SHIPPED, CANCELLED
	total_amount FLOAT,
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
)
CREATE TABLE orderDetail (
    orderId VARCHAR(50) NOT NULL,
    itemType VARCHAR(20) NOT NULL, 
    itemId VARCHAR(50) NOT NULL,   
    unitPrice FLOAT NOT NULL,
    unitQuantity INT,
    PRIMARY KEY (orderId, itemType, itemId),
    FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE
)

 --thêm 1 bảng để chứa ảnh cho trang home.jsp.
CREATE TABLE home_gallery (
    id INT IDENTITY(1,1) PRIMARY KEY,
    image_url VARCHAR(255),
    caption VARCHAR(255),
    display_order INT NOT NULL DEFAULT 0,
    description VARCHAR(MAX), 
	type varchar(50),
    created_at DATETIME DEFAULT GETDATE()
);

-- thêm 1 bảng để nhận contactMess của customer.
CREATE TABLE ContactMessages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    email NVARCHAR(100),
    message NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);


CREATE TABLE customer_cart (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL, 
    item_type VARCHAR(20) NOT NULL, -- 'MODEL' hoặc 'ACCESSORY'  
    item_id VARCHAR(50) NOT NULL,
    item_name NVARCHAR(255) NOT NULL, 
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    -- Tránh trùng lặp sản phẩm cho cùng 1 khách hàng
    CONSTRAINT unique_customer_item UNIQUE (customer_id, item_type, item_id),
    
    -- Foreign key với bảng customer 
    CONSTRAINT FK_customer_cart_customer 
        FOREIGN KEY (customer_id) REFERENCES customer(customerId) ON DELETE CASCADE
);

INSERT INTO customer (customerId, customerName, email, phone, address) VALUES
('C001', 'Admin User', 'admin@diecast.com', '0123456789', 'Admin Street, Admin City'),
('C002', 'Normal User', 'user@diecast.com', '0987654321', 'User Avenue, User Town'),
('C003', 'Banned User', 'banned@diecast.com', '0112233445', 'Banned Alley, No Access');

INSERT INTO customerAccount (userName, customerId, password, role) VALUES
('admin', 'C001', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 1),        -- admin account
('user1', 'C002', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 2),         -- normal user
('banned1', 'C003', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 0);

INSERT INTO brandModel (brandName) VALUES 
('MiniGT'),
('Hot Wheels'),
('Bburago'),
('Maisto'),
('Tomica'),
('AutoArt'),
('GreenLight'),
('Kyosho'),
('Matchbox'),
('Welly')

INSERT INTO scaleModel (scaleLabel) VALUES
('1/64'),
('1/24');

INSERT INTO modelCar (modelId, modelName, scaleId, brandId, price, description, quantity) VALUES
('MGT002', 'Model car of Toyota Supra A90 Pandem scale 1:64 MiniGT', 1, 1, 18.71, 'This 1:64 die‑cast replica of the Toyota GR Supra comes fitted with an eye-catching widebody Pandem kit—aggressive fender flares, sculpted front bumper, sharp side skirts, and an imposing rear diffuser culminate in a stunning rear spoiler. Made by Ignition Model (or similar brands like MINI GT/TrueScale), the model features high-quality die‑cast alloy construction with rubber tires on intricately detailed rims, showcasing real vehicle authenticity. A meticulous multi-layer electrostatic finish—available in striking pearl white, vibrant pink, neon green, bold blue, matte grey, or glossy metallic shades—ensures crisp body lines and long-lasting color . Every exterior element is faithfully recreated: etched “Pandem” decals on the fenders and spoiler, precise head and taillight detailing, and authentic Supra badging complete the visual realism. Housed on a display base with acrylic cover, the model measures about 7.5 cm long and includes premium touches like rubberized wheels, optional BBS-style rims, and an aluminum nameplate. Compact but powerful, this Pandem Supra is perfect for collectors who appreciate Japanese tuner culture—ideal for showcasing on a shelf, desk, or diorama. It is a standout statement piece blending precision craftsmanship with bold modified styling.', 120),
('HW002', 'Model car of Ford Mustang GT scale 1:64 Hot Wheels', 1, 2, 10.42, 'This 1:64-scale Hot Wheels Mustang GT perfectly captures the essence of the iconic American muscle car in compact form. Built with a solid die-cast metal body and chassis, it features simple yet authentic details: the strong body lines, signature pony grille, and bold rear spoiler. Finished in vivid spectra‑flame-style paint—usually in red, blue, silver, or black—the model gleams with the brand’s classic aesthetic and is highly eye-catching even at small scale. Hot Wheels crafted this version for their mainstream line, balancing collector appeal with everyday fun. The rolling plastic wheels are designed to spin smoothly on tracks or desktop surfaces, making it perfect for both display and play . While it doesn’t include Car Culture level rubber tires or premium features, it still offers excellent visual fidelity—featuring correctly proportioned headlights, taillights, and Mustang GT badging. Collectors praise this Mustang for its straightforward, faithful design and vibrant color options. A Reddit user shared their excitement on finding it in stores, recounting how they scored it before other collectors spotted it. As a simple yet striking piece, this Hot Wheels Mustang GT is ideal for fans of American muscle, casual collectors, or anyone seeking a stylishly bold addition to their 1:64 collection.', 250),
('BBR002', 'Model car of Lamborghini Huracán EVO scale 1:24 Bburago', 2, 3, 29.17, 'The 1:24-scale Bburago Lamborghini Huracán Performante EVO is a stunning collector-grade replica that fully embodies the aggressive elegance of the Italian supercar. Measuring about 7.25″ long, 3.25″ wide, and 2″ tall, it features a sturdy die-cast metal body with precise plastic detailing, including the iconic rear spoiler and bumper-integrated diffuser that amplify its aerodynamic stance. This model impresses with fully functional doors that open to reveal a well-sculpted cabin—seats, dashboard, steering wheel, and console all faithfully recreated. The real tour-de-force is the rear-engine bay: a transparent glass cover showcases the finely detailed V10 engine beneath, a highlight for any Lamborghini enthusiast. Bburago adds authenticity with steerable front wheels and rubber tires, allowing for realistic positioning on display surfaces. The ultra-smooth, high-gloss finish—available in metallic orange, black, or other signature Lamborghini tones—accentuates its sharp body lines and sculptural profile. As part of Bburago is long-standing tradition of producing well‑made 1:24 Italian supercars, this Huracán model balances aesthetic precision and tactile interaction. It’s the perfect showcase piece for fans of Italian automotive design and collectors seeking a detailed, showroom-ready model with true high-performance flair.', 60),
('MST001', 'Model car of Chevrolet Camaro ZL1 scale 1:24 Maisto', 2, 4, 27.08, 'The Maisto 1:24-scale Chevrolet Camaro captures the essence of the iconic American muscle car with striking, sporty aesthetics. Approximately 8 inches long, it features a robust die-cast metal body and chassis, complemented by detailed plastic accents and authentic rubber tires that roll smoothly—ideal for both display and light play. This model includes fully functional doors and a hinged hood (and trunk on convertible editions), allowing a clear view of the realistic interior and engine bay. Inside, the sculpted seats, dashboard, and steering wheel are rendered with solid attention to proportion and texture . Push the hood up, and you will find a detailed V‑8 engine block—a nod to the car’s famed power. Finished in bold, American-style hues—such as Hyper Blue, vibrant orange, or classic burgundy—the Camaro showcases crisp paint and clean muscle-car lines. Collectors appreciate its balance of sturdy construction and visual details; one Redditor even praised the model’s exceptional passenger cabin: “I said ‘wow the interior is very detailed for something that small.” As part of Maisto’s Special/Assembly Line range, this Camaro blends eye-catching design with interactive features at an affordable price. It’s a standout piece for muscle car fans and die-cast collectors alike—offering a tactile, showroom-quality miniature with authentic American heritage flair.', 80),
('TMC001', 'Model car of Nissan Fairlady Z scale 1:64 Tomica', 1, 5, 16.63, 'The Tomica 1:64-scale Fairlady Z is a compact yet carefully crafted die‑cast replica that captures the timeless elegance of Nissan is iconic sports coupe. Measuring around 3 inches, it features a sturdy metal body and chassis, smooth-rolling wheels, and crisp plastic detailing—highlighting the classic Z‑car silhouette with roofline curves and muscular fenders. Each model is finished in glossy paints like silver or deep green, with precise panel lines, etched grille, and authentic Z badging. The clear headlight lenses and sculpted taillights enhance realism uncommon in mainstream 1:64 models . As one collector on Reddit noted, “That’s 1/64 diecast size right? … 1/58 scale. … Premiums are pretty good … Quality is worth the money”. Collectors appreciate how Tomica nails the right balance—offering more detail than Hot Wheels while remaining durable and affordable. Another Redditor explained that Tomica models use decals or photo-etched elements instead of printed tampo, elevating the finish. Though opening parts are rare in this line, the model shines through authentic paint quality, proportionate design, and collector-grade charm. Ideal for display, dioramas, or casual play, this Fairlady Z brings classic Japanese automotive heritage to your shelf in a pocket‑friendly, precision-crafted package.', 150),
('AAT001', 'Model car of Porsche 911 GT3 RS scale 1:24 AutoArt', 2, 6, 83.29, 'The AUTOart 1:24-scale Porsche 911 GT3 RS is a premium collector’s piece that flawlessly captures the athletic spirit and track-focused aesthetics of the celebrated Porsche sports car. Crafted with precision using composite ABS and die-cast components, it replicates sharp panel lines, detailed vents, and a commanding rear wing—elements clearly praised in reviews for their exactness and build quality. This model includes fully opening doors, a hinged hood, and a lift‑off engine cover—revealing a meticulously detailed interior and engine bay. Inside, you’ll find carpet-like textures, precise gauge clusters, a detailed center console, and lightweight racing seats, while the rear compartment includes a stunning, track-ready engine replica. Collectors love the exterior is immaculate finish: vibrant colors like Lava Orange, Guards Red, or metallic black resonate well in the model’s clean, consistent paint. The fine grille meshes, translucent headlights, and realistically textured brake rotors showcase AUTOart’s dedication to detail. Reddit users note that though some might argue proportions are slightly off (wheel arches on early 997 GT3 RS versions), the overall craftsmanship earns high praise—“AutoArt’s Porsche 911 (991) GT3 RS is an outstanding piece from all angles”. Overall, this 1:24 GT3 RS delivers a high-end user experience, blending functional realism with breathtaking aesthetics—ideal for display, enthusiast collections, or professional-grade model showcases.', 30),
('GL001', 'Model car of Dodge Charger R/T scale 1:64 GreenLight', 1, 7, 11.46, 'The GreenLight 1:64-scale Dodge Charger R/T brings classic American muscle car style in miniature form. This model features a solid die-cast metal body and chassis, complemented by real rubber tires and rolling wheels—offering both display quality and playability. Its design captures the Charger R/T’s bold presence: long hood, assertive stance, signature grille, chrome bumpers, R/T badging, and optional period details like racing stripes and hood scoops. Popular editions include classic black “Bullitt” replicas, vibrant Bengal orange, and Barrett-Jackson green-scene special runs. Packaged in a collector-friendly blister card, this Charger is part of GreenLight’s Monster & Muscle or Muscle Series—designed for fans of both vintage and movie-inspired cars, including those featured in Fast & Furious and John Wick. Enthusiasts on Reddit often praise GreenLight’s realistic casting and sturdy construction. One user noted when comparing 1:64 muscle cars: “Want good detail & proportion in 1/64 scale always bet on GreenLight”. Overall, this Charger R/T model blends iconic styling, rugged detailing, and collectible appeal—ideal for anyone craving a slice of vintage American muscle in a pocket‑sized package.', 100),
('KYO001', 'Model car of Mazda RX-7 FD3S scale 1:24 Kyosho', 2, 8, 41.63, 'The Kyosho 1:24-scale RX‑7 FD3S is a standout replica that captures the legendary Japanese sports car in meticulous detail—ideal for JDM enthusiasts and collectors. Stretching roughly 7 inches long, it sports a sturdy die-cast metal body finished in a glossy lacquer, with a sculpted rear spoiler, realistic side mirrors, and aerodynamic styling true to the iconic FD3S silhouette. Opening elements such as the front doors and hinged hood reveal a richly detailed interior: contoured racing seats, a precise dashboard, and steering wheel all rendered with care, while the engine bay showcases the famous rotary engine—faithful to Mazda’s innovative design . The model sits on realistic rubber tires mounted on finely sculpted rims, and the front wheels steer smoothly for dynamic display setups. Kyosho’s craftsmanship is highly praised by collectors: the FD3S’s pop-up headlights and sculpted lines are praised for “breathtaking” accuracy—even at this larger 1:24 scale. Overall, this model blends tactile features and visual precision—making it a true celebration of Mazda’s rotary heritage and a must-have for any serious scale-car collector.', 45),
('MTB001', 'Model car of Volkswagen Beetle scale 1:64 Matchbox', 1, 9, 16.67, 'The Matchbox 1:64-scale Volkswagen Beetle captures the iconic rounded silhouette of the classic “Bug” in miniature form. With a solid metal body, flexible rubber-style wheels, and smooth-rolling action, this little Beetle evokes nostalgia while offering durable playability—perfect for both kids and collectors. Measuring just about 3 inches long, it faithfully recreates the Beetle’s distinctive curves, roofline, and fender bulges, finished in fun, eye‑catching colors like pastel green, white, or vibrant red. Though no opening parts are featured, the Beetle stands out for its solid build, appealing proportions, and vintage flair. It arrives in Matchbox’s signature blister-pack, making it display-ready straight from the shelf.Compact, durable, and full of nostalgic appeal, this Matchbox Beetle is ideal for young drivers or collectors who admire classic European car icons. Its blend of simplicity, quality, and timeless design makes it a standout addition to any 1:64 die‑cast collection.', 200),
('WLY001', 'Model car of BMW M3 E30 scale 1:24 Welly', 2, 10, 33.29, 'The Welly 1:24-scale BMW M3 E30 is a superbly detailed die-cast replica that faithfully captures the boxy charm and sporty essence of the iconic 1980s racer. Measuring approximately 7 inches long, it features a robust metal body and chassis, complemented by plastic trim and realistic rubber tires that roll smoothly—ideal for both display and light handling. Notable features include fully opening doors and a hinged hood that reveals an intricately modeled inline‑4 engine bay. Inside, the cabin is replicated with great care: detailed seats, accurate dashboard instrumentation, and a precise steering wheel all enhance its authenticity. The exterior stands out with the classic square front end, twin circular headlights, signature rear spoiler, and period‑correct multi‑spoke wheels—a nod to its racing heritage. A Redditor praised Welly’s value in 1:24 scale, noting they’re “decent i have few… I’d put Welly, M2, Greenlight and motormax all in the same category”. Another mentioned being “impressed with their products… Excellent collection and taste!”. Whether on a desk, shelf, or part of a racing diorama, this Welly E30 M3 offers collectible charm, robust build quality, and nostalgic appeal for BMW fans. It’s an accessible yet attractive choice for anyone looking to display a piece of BMW history.', 70),
('MGT003', 'Model car of Honda Civic Type R FK8 scale 1:64 MiniGT', 1, 1, 20.83, 'The MiniGT 1:64-scale Civic Type R (FK8) replicates the high-performance hatchback in stunning miniature detail. Measuring approximately 7 cm long with a solid die-cast metal body and chassis, rubber-style tires, and realistic aerodynamic details like the pronounced rear wing and aggressive front fascia, it captures the essence of JDM engineering in a compact form. Premium finishes—including Championship White, Phoenix Yellow, Slate Grey, and Art Car Manga editions—boast ultra-smooth electrostatic or lacquered paintwork. Carefully executed decals mirror the FK8’s racing lineage and sharp styling cues . The model doesn’t feature opening parts (doors remain static), but wheels roll cleanly and proportions are spot-on, offering satisfying display-ready realism. Collectors on Reddit praise its craftsmanship. One enthusiast called it “probably the best livery they’ve done on the Civic”, while another pointed out that MiniGT’s QC has markedly improved in recent years. The FK8 stands out even among MiniGT models as a top-tier casting. Designed for ages 14+ and intended for display—not rough play—this Type R is ideal for Japanese car lovers and hatchback fans. Its sharp design, faithful details, and collectible packaging make it a standout piece in any 1:64 JDM lineup.', 110),
('HW003', 'Model car of Tesla Model S scale 1:64 Hot Wheels', 1, 2, 18.96, 'The Hot Wheels 1:64-scale Tesla Model S brings the pioneer of electric vehicles to the palm of your hand. This model features a die-cast metal body and chassis, with smooth-rolling plastic tires, capturing the sleek, aerodynamic design of the full-size sedan—including its signature low front fascia and retractable door handles—even at compact scale. Available in stylish finishes like metallic silver (HW Workshop: Garage series), deep black, white, and metallic blue from the Green Speed and Factory Fresh lines, each casting even incorporates subtle details: painted headlights and taillights, Tesla logos on front and rear, and even a ducktail-style spoiler for sporty flair. Launched in 2015 through a collaboration with Tesla, this toy version mirrors the real car is eco-luxury ethos—“the ultimate in eco‑friendly luxury… boasting 302 hp” in miniature form. Priced as a mainstream release, it offers exceptional value for collectors and fans of sustainable automotive design. Though simple in features (no opening parts), this Tesla Model S casting emphasizes visual fidelity and Hot Wheels’ classic playability. Ideal for tech enthusiasts, eco-conscious collectors, or EV fans, this model blends environmental innovation with iconic design in a pocket-sized collectible. It is a perfect conversation starter and shelf accent for lovers of electric mobility and futuristic cars.', 180),
('BBR003', 'Model car of Ferrari 488 GTB scale 1:24 Bburago', 2, 3, 35.21, 'The Bburago 1:24-scale Ferrari 488 GTB is a striking die‑cast replica that perfectly captures the essence of Ferrari’s mid-engine V8 supercar. Built with a sturdy metal body and chassis, it measures about 7 – 8 inches long and features high-gloss, electrostatic paint that vividly mirrors the luxurious finish of the real car. The model offers realistic opening features—including front doors, hood, and rear engine cover—unveiling a finely detailed interior and the iconic twin-turbo V8 beneath the transparent engine lid. The sculpted cabin includes authentic seats, dashboard layout, steering wheel, and pedals, enhancing its display appeal. Externally, this model pays homage to the 488 GTB’s athletic design: sharp aerodynamic lines, aggressive front grille, signature LED headlight shapes, sleek side intakes, and the prominent Ferrari prancing horse on the hood. Accent details like rubber tires, steerable front wheels, and realistic alloy-style rims contribute to the overall dynamic stance. As a licensed product from Bburago—now under the May Cheong Group—this 1:24 488 GTB combines collector‑level aesthetics and interactive functionality at an accessible price point. Ideal for Ferrari collectors and performance car enthusiasts alike, it’s a showpiece that delivers style, realism, and tactile engagement.', 55),
('MST002', 'Model car of Jeep Wrangler Rubicon scale 1:24 Maisto', 2, 4, 36.67, 'The Maisto 1:24-scale Jeep Rubicon brings rugged trail-ready attitude to your collection. Around 7 inches long, this model features a lifted chassis, oversized rubber-style tires, and Maisto’s signature seven-slot grille—capturing the adventurous spirit of the real off‑road icon. The detailed metal body includes an opening hood that reveals a sculpted engine bay. Inside, the cabin features molded seats and dashboard layout that echo the Rubicon’s utilitarian interior. The high-clearance chassis and large wheels give it a commanding stance—ideal for off‑road enthusiasts looking for a compact collector’s piece. Collectors highlight Maisto is consistent value in 1:18 and 1:24 scales—one fan praised the Rubicon model’s quality: “Maisto made this model so good when compare price/quality”. Available in classic off-road tones—such as Jeep green, black or metallic blue—each model is display-ready and built with durable construction. Its rolling wheels and sturdy design make it a winner for fans who appreciate Jeep heritage and exploration. Whether showcased on a shelf or desk, the Maisto Jeep Rubicon embodies ruggedness, versatility, and collector-friendly craftsmanship.', 65),
('TMC002', 'Model car of Suzuki Jimny scale 1:64 Tomica', 1, 5, 41.63, 'The Tomica 1:64‑scale Suzuki Jimny packs authentic charm into a compact die‑cast replica. Measuring about 3 inches long, it features a sturdy metal body with crisp plastic trim, rolling wheels, and true-to-life proportions that echo the Jimny’s iconic boxy silhouette and upright shape. Its exterior reflects the model is rugged identity: square headlights, seven-slot grille, pronounced fender flares, and realistic side mirrors. Eye‑catching vibrant paint finishes—lime green, blue, or yellow—enhance its toy-like yet collectible appeal . While opening parts aren’t featured, attention to detail is clear in the hatchbacks and tail light molds. Colloquial reviews note that this Jimny was a Walmart-exclusive release in 2019 across the US, Canada, and Australia, making it a popular find for collectors. Its suspension feature (Tomica’s hallmark) gives wheels a slight bounce, adding playful interaction for casual play or display. Although Reddit discussions highlight Tomica’s quality‑control concerns, the Jimny remains well-regarded for its appealing design, strong color schemes, and durable build. Ideal for Japanese‑car enthusiasts, children, or collectors leaning towards nostalgic minis, this Tomica Jimny brings both cuteness and cultural recognition in one tiny package.', 140),
('AAT002', 'Model car of McLaren P1 scale 1:18 AutoArt', 1, 6, 104.13, 'The AUTOart 1:18-scale McLaren P1 is a standout collectible that meticulously recreates McLaren’s hybrid hypercar icon. Crafted as part of AUTOart is elite Signature Series, the model utilizes composite materials to deliver sharp lines and a precise fit-and-finish. It even includes full butterfly doors, a removable rear section, and folding roof flaps that closely resemble those of the real vehicle. Under the rear canopy, the engine bay reveals a detailed twin-turbo V8 hybrid powertrain, although some collectors feel it lacks the depth expected—this seems to be a rare critique amidst high praise . Inside, the cockpit is richly appointed with carpeted floors, seat-belts, alloy pedals, and a sculpted dashboard—interior craftsmanship that enthusiasts admire. Exterior paint options—ranging from Volcano Orange and Azure Blue to Metallic Black—are flawlessly smooth and glossy, reflecting AUTOart’s reputation for superb finishes. The front grilles feature mesh inserts, the headlights and brake rotors are realistic, and wheels are crisply detailed with red brake calipers. Fans note that the P1 model is one of the best in value-for-price among hypercar replicas: “AutoArt Signature… P1 in Volcano Orange by Autoart”. While some prefer the engine detail of alternative brands, most collectors agree this P1 delivers an impressive balance of detail, function, and visual drama—making it a true centrepiece for any serious scale model collection.', 25),
('GL002', 'Model car of Chevrolet Impala SS scale 1:64 GreenLight', 1, 7, 20.79, 'The GreenLight 1:64-scale Chevrolet Impala SS captures the timeless silhouette of the classic American full-size sedan. With its long body, sweeping roofline, and elegant proportions, this model exudes nostalgic charisma. It features a solid die-cast metal body and chassis, smooth-rolling rubber-style tires on authentic wheels, and intricate chrome detailing on the grille, bumpers, and side trim—true to the Impala SS heritage. Released in GreenLight is popular Lowrider and California Lowriders series, editions like the 1963 and 1964 Impala SS come in vibrant colors—metallic gold, purple, black, white, and blue—with limited-run Mijo-run variants packaged in collector-friendly blister cards. These versions often include rubber tires and suspension features that emulate the lowered, custom-lowered stance of real lowriders—ideal for display or shelf lineup. Collectors familiar with GreenLight praise the build quality for offering movie‑ready castings at 1:64 scale. One Redditor observed: “If you are on a budget – 1/64 and GreenLight has your movie car needs met”. Another shared enthusiasm over the Lowrider series, highlighting its standout casting and colors. Bringing together classic styling, durable construction, and nostalgic appeal, this Impala SS is perfect for fans of vintage American cars—especially those who appreciate the grandeur of the SS series and iconic Lowrider culture.', 90),
('KYO002', 'Model car of Subaru Impreza WRX STI scale 1:24 Kyosho', 2, 8, 37.46, 'The Kyosho 1:24-scale WRX STI captures the rally-bred prowess of Subaru’s performance icon in stunning detail. About 7 inches long, it features a die-cast metal body finished with glossy paint, bold hood scoop, functional rear spoiler, and accurately replicated Subaru badging and aero elements—reflecting the STI’s aggressive, race-inspired design. Opening hood and doors reveal a precisely sculpted interior and engine bay. Inside, you’ll find detailed bucket seats, a realistic dashboard layout, and molded steering wheel, while under the hood sits a convincing turbocharged boxer engine replica—ideal for close-up display. The front wheels are steerable, and the rubber tires sit on rally-style rims, completing the dynamic look. Collectors praise Kyosho’s attention to scale and finish. As one Redditor shared: “Kyosho does it best. They are the reason I got back into the collecting hobby.”. Another noted the brand’s quality history: “I have over 120 different Kyosho castings… When it comes down to detail they were the best 10 years ago.”. While QC and pricing have varied, the STI model remains a favorite for Japanese performance car fans seeking tactile features and authentic rally car aesthetics. Rugged, collectible, and finely crafted—the Kyosho WRX STI is a standout model for any JDM or rally enthusiast.', 50),
('MTB002', 'Model car of Land Rover Defender 90 scale 1:64 Matchbox', 1, 9, 31.25, 'The Matchbox 1:64-scale Defender 90 is a compact yet rugged mini replica that perfectly embodies the classic British off‑roader. At about 3 inches long, it features a sturdy metal body and chassis with smooth-rolling wheels—ideal for both kids and collectors seeking durable playability. Its design captures key Defender traits: the squared-off boxy silhouette, seven-slot grille, exposed wheel arches, and a paint finish reminiscent of expedition-ready vehicles—typically in matte greens, stone beige, or utility grey. Though it lacks opening parts, the model faithfully represents the rugged styling and proportions—making it a beloved piece for shelf displays or off-road dioramas. Collectors often note Matchbox’s attention to sturdy build and aesthetic accuracy at this scale. As one Redditor mentioned, while the Hot Wheels Premium Defender impressed, the Matchbox version “has a nice Range Rover,” implying strong comparison. Another discussion highlighted that scale can vary slightly in 1:64 models, but overall feel and authenticity are what collectors appreciate.Perfect for fans of classic off-road vehicles, this Defender 90 pairs nostalgic charm, solid construction, and timeless style in a pocket-sized format—ideal for collectors who love rugged British classics.', 190),
('WLY002', 'Model car of Audi R8 V10 Plus scale 1:24 Welly', 2, 10, 31.25, 'This Welly 1:24-scale Audi R8 V10 replica delivers luxury supercar appeal with exquisite detail at an accessible price. Crafted from durable die-cast alloy, it measures roughly 18 cm long and features opening doors, an opening hood and trunk, allowing full exploration of the interior and engine bays. The model boasts a realistic cabin layout with sculpted seats, dash, steering wheel, and pedals. Its standout feature is the transparent rear cover showcasing a finely molded V10 engine—true to the real car is lineage. Exterior highlights include LED-style headlights, side-air intakes, signature Audi grille, and a sleek low-profile design, all enhanced by a smooth, high-gloss metallic finish available in white, black, red, yellow, blue, and matte black variants. Hot on Reddit, users praise Welly’s model quality for its price: “it probably the best 1:24 for the money”,  “A Welly Audi R8 V10 in white. One of my favorite cars”. With steerable front wheels and rubber-style tires, this R8 combines visual accuracy, interactive features, and robust build. It’s an ideal display piece or gift for fans of high-performance European supercars who appreciate craftsmanship and value.', 75);


INSERT INTO modelCar (modelId, modelName, scaleId, brandId, price, description, quantity) VALUES
('BBR004', 'Model car of Alfa Romeo Giulia scale 1:24 Bburago', 2, 3, 24.00, 'The 1:24-scale Bburago Alfa Romeo Giulia is a beautifully crafted die‑cast replica that captures the sleek elegance of the real 2016–17 Giulia. Measuring about 7.5 inches long, 3 inches wide, and 2.5 inches tall, this model combines metal and plastic parts to faithfully recreate the iconic Italian sedan. Its deep paint finish—available in striking burgundy, classic red, or metallic blue—evokes the refined aesthetics of the full-size car . The model features real rubber tires on steerable front wheels and includes opening front doors and a functional bonnet that reveals a detailed engine bay underneath—perfect for display or hands‑on interaction.Inside, the cabin shows impressive attention to detail: visible dashboards, seats, pedals, and console rail true-to-life trim. The exterior detail is equally notable, showcasing precise front grilles, side mirrors, and Alfa Romeo badging—a testament to Bburago’s dedication to realism.As part of Bburago’s 1:24 series—Italian-designed and enthusiast-loved—this Giulia model blends craftsmanship with playability. Whether as a collector’s display piece or a gift for car lovers, it brings a slice of Italian automotive passion into any home or office.', 40),
('MST003', 'Model car of Mercedes‑Benz G‑Class scale 1:18 Maisto', 1, 4, 29.17, 'The Maisto 1:18-scale Mercedes‑Benz G‑Class is a meticulously crafted die‑cast replica that’s both striking and functional. Coming in bold colors like red or metallic grey, this model stretches approximately 7.5 inches long, 3 inches wide, and 3 inches tall. Built with a blend of metal and plastic, it features smooth‑rolling rubber tires, realistic side steps, and a rugged, boxy shape that echoes the real G-Wagon’s commanding presence. The attention to detail is impressive: you can open the front doors to reveal a fully detailed interior—including dashboard, seats, and rear seating area. The model also offers a functional bonnet that exposes an engine bay and a movable steering mechanism tied to the front wheels . Its premium paint finish, whether glossy or metallic, emphasizes the G-Class’s iconic design elements, such as the prominent grille, round headlights, and rugged bumpers. Part of Maisto’s Special Edition series, this G-Class model combines visual appeal and hands-on play. Whether displayed on a shelf or driven across smooth surfaces, it’s a robust collectible that reflects Maisto’s commitment to quality at an affordable price. An excellent gift for enthusiasts and children, it encapsulates the adventurous spirit of the Mercedes G‑Class in miniature form.', 35),
('HW004', 'Model car of Ford F‑150 Raptor scale 1:24 Hot Wheels', 2, 2, 15.00, 'The Hot Wheels 1:24-scale Ford F‑150 Raptor is a detailed and dynamic die-cast replica that perfectly captures the rugged ethos of the real truck. Sporting vibrant paint—including the popular green and striking desert rally liveries—it measures approximately 7–8 inches long and sits on realistic rubber tires, bringing authenticity to its off-road stance. What collectors love most is the handiwork in detail and playability. One enthusiast described it as “amaz­ing…with working doors and a hood that opens,” and praised the “attention to detail…down to the decals and tires”. These features truly bring it to life on both shelf and play display. Others enjoy the broader aesthetic: “I have always been a die-hard fan…attention to detail on this bad boy is impeccable”. Additionally, the model occasionally appears in limited-run liveries—like the HKS scheme—making it a sought-after find. Reddit users noted its rarity but assured others it’s not impossible to locate: some stores even had multiple pieces in stock.Overall, this Hot Wheels Raptor balances collector appeal with rugged charm. It’s ideal for display or imaginative play, offering real truck styling and surprise detail in an accessible 1:24 scale.', 60),
('GL003', 'Model car of Corvette C8 scale 1:64 GreenLight', 1, 7, 22.92, 'The GreenLight 1:64-scale Chevrolet Corvette C8 is a finely detailed die-cast replica that captures the dynamic persona of America’s mid-engine sports icon. Measuring about 2.75–3 inches long, this compact model blends a sturdy metal body and chassis with plastic components and real rubber tires—perfectly conveying the sleek, precise appearance of the full-size car. Each release features authentic liveries and colorways: standouts include the glossy black “Black Bandit” convertible, crisp white with blue racing stripes, earthy “Caffeine Metallic” coupe from the Showroom Floor Series, and the yellow Shell Oil or Barrett‑Jackson pace car editions . These limited-run liveries often celebrate special events—Indy 500, Road America—and are officially licensed, making them sought-after by collectors. Enthusiasts praise the true-to-scale exterior detailing—sculpted air intakes, accurate Corvette insignia, and a sharp mid-engine profile. Rubber tires give it a realistic stance, and the blister pack keeps it display-ready. Despite its small size, this GreenLight model packs collector appeal: rugged, precise, and stylish—ideal for Corvette fans or anyone who appreciates high-quality miniature craftsmanship.', 130),
('KYO003', 'Model car of Nissan GT‑R R35 scale 1:24 Kyosho', 2, 8, 41.63, 'The Kyosho 1:24-scale Nissan GT‑R (R35) is a finely crafted die-cast collectible that mirrors the design and spirit of Nissan’s iconic supercar. With a sturdy metal body and realistic rubber tires, this model emphasizes both form and function—perfectly embodying the R35’s muscular stance and dynamic detailing. The exterior showcases precision-engineered features: intricately molded front grilles, sculpted hood lines, and an authentic rear spoiler. Clear plastic lighting units and accurate GT‑R badging replicate the real car is aggressive presence. Some versions include a display-grade chassis, allowing it to be shown as a static model or paired with a Mini‑Z remote-controlled base for speed enthusiasts. Though this 1:24 version of Mini‑Z isn’t fully RC-ready like the 1:28 First series, it remains a standout in Kyosho’s lineup. It celebrates the R35 is legacy—a supercar born from meticulous engineering and performance ethos . Presented in rich, factory-finish paint options—from classic silver to bold pearl and stealthy matte tones—it is a striking addition to any display shelf or racing diorama. Overall, the Kyosho 1:24 GT‑R R35 melds collector-grade detailing with sturdy construction, capturing the essence of Nissan’s performance legend in miniature form.', 50),
('AAT003', 'Model car of BMW i8 scale 1:18 AutoArt', 1, 6, 104.13, 'The AUTOart 1:18-scale BMW i8 is a premium composite model that beautifully mirrors the futuristic hybrid sports car’s sleek, aerodynamic design. At around 10.5 inches long, the model combines an ABS and die-cast metal body for ultra-precise panel lines and lightweight build—AUTOart’s signature composite approach ensures exceptional detail accuracy. Opening butterfly doors swing up effortlessly, revealing an immaculate interior with carpeted floors, sculpted seats, and realistic dashboard trim. As some Reddit users note, "mesh grilles are to scale and the interior actually has alcantara in the dash and seat"—a testament to the model’s immersive authenticity. The exterior shines in vibrant finishes like Protonic Blue, Sophisto Grey, or Crystal White, with subtle BMW i‑blue accents along the grilles and bodywork enhancing its futuristic aura.Functional details include steerable front wheels and finely drilled brake discs. Although the hood does not open—as in the real car—it stays true to the design ethos and isn’t a drawback for this electric-hybrid replica. The headlights and taillights feature realistic plastic inserts, beautifully capturing the i8’s distinctive lighting signature. AUTOart’s reputation for craftsmanship is well-earned—many collectors on Reddit advise: "Go with Autoart if you have enough money. If not, go Kyosho. These two make the best BMW models I have ever seen". Overall, this BMW i8 model is a stunning display piece, combining visual elegance with collector-grade quality.', 20),
('MTB003', 'Model car of Volkswagen Golf GTI scale 1:64 Matchbox', 1, 9, 12.50, 'The Matchbox 1:64-scale Volkswagen Golf GTI is a compact, high-quality die-cast replica that captures the hot‑hatch spirit of the iconic GTI line. Measuring around 3 inches long, this model features a metal body and chassis with precise plastic trim, mimicking the distinctive GTI elements—such as the honeycomb grille, red accent line around the front bumper, and realistic taillights. Available in standout finishes like classic red, black from the Germany Series, vibrant green or blue retro‑style castings, this collectible appeals to both casual fans and serious collectors . The attention to detail is evident in the sculpted alloy-style wheels, smooth-rolling rubber-style tires, and interior seat outlines visible through the windows. Packaging ranges from the nostalgic blister-card to collectors’ editions (e.g., Stars of Germany 8/12). Part of Matchbox’s ongoing tribute to German engineering, this GTI model combines striking aesthetics with robust construction. Its small scale makes it perfect for desk display, shelf decor, or slot-car dioramas. Whether it’s a standalone piece or part of a broader collection, the Matchbox Golf GTI is a timeless tribute to an automotive legend—ideal for fans of classic touring icons and miniature craftsmanship alike.', 150),
('MST004', 'Model car of Dodge Viper ACR scale 1:24 Maisto', 2, 4, 33.33, 'The Maisto 1:24-scale Dodge Viper ACR model is a powerful and highly detailed die-cast replica of the legendary American supercar. Crafted with a robust blend of die-cast metal and plastic components, it measures approximately 7–8 inches in length—ideal for display or handling. This edition typically features realistic rubber tires and free-rolling wheels, enhancing its lifelike stance. True to Maisto’s Assembly Line/Special Edition line, the model offers opening doors and a front bonnet that lifts to reveal a finely crafted engine bay—mirroring the Viper’s potent V10 powerplant. Inside, the sculpted interior shows impressive detail, including molded seats, dashboard, and steering wheel. The exterior wears vibrant, factory-style finishes—red, blue, or metallic hues—emphasizing the aggressive curves, side vents, and signature Viper contours. Maisto’s approach balances ease and authenticity: the model needs minimal assembly (if any) and offers plug-and-play enjoyment, while still delivering collector-quality craftsmanship.  As part of a well-known line produced in China and Thailand, it’s praised for its excellent price-to-detail ratio. Whether you are a die-hard Viper enthusiast or seeking a standout desk display, the Maisto 1:24 Dodge Viper ACR combines bold styling, functional features, and tactile interaction—bringing the raw energy of the Viper into your home in miniature form.', 45),
('TMC003', 'Model car of Subaru BRZ scale 1:64 Tomica', 1, 5, 16.25, 'The Tomica 1:64-scale Subaru BRZ is a compact yet remarkably detailed die‑cast model from Takara Tomy’s renowned Tomica line—often dubbed the “Japanese Matchbox”. Measuring approximately 3 inches long, it features a solid metal body and chassis, precise plastic trim, and smooth-rolling wheels that reflect the BRZ is sporty spirit. Its exterior finish stands out in vibrant colors like bold red or sleek blue, accurately portraying the BRZ’s coupe profile, front grille, and lighting details. Subtle sculpting highlights include air intakes, side skirts, and a realistic rear spoiler. Though full-scale opening parts are rare in this size, the model delivers impressive presence through its authentic paint quality and sharp styling. Reddit collectors praise Tomica Premium and main-line models alike for their paint and detailing. One user remarked that the “Subaru BRZ has a phenomenal paint job… Comes with lensed front and rear lights… I love the wheels”. While some Tomica Premium cars may vary slightly from exact 1:64 scale, this BRZ captures the essence of the real car with charm and collectibility. Whether part of a collection, displayed on a desk, or gifted to a car lover, the Tomica Subaru BRZ offers a satisfying miniature representation of Subaru’s rear‑drive sports coupe—combining style, quality, and nostalgia in one pocket‑sized package.', 110),
('BBR005', 'Model car of Lamborghini Aventador scale 1:24 Bburago', 2, 3, 37.50, 'The Bburago 1:24-scale Lamborghini Aventador LP 750‑4 SV is a spectacular die-cast model that brings the essence of the supercar into your hands. Crafted mostly from metal with plastic accents, the model boasts authentic rubber tires, steerable front wheels, and striking SV-inspired styling in vibrant colors like red, orange, silver, or gold. Measuring about 7¼" long, 3¼" wide, and 2" tall, it faithfully replicates the Aventador’s low, aggressive stance and iconic scissor doors. These doors swing open smoothly to reveal a richly detailed interior—complete with folding bucket seats, dashboard gauges, a precise steering wheel, and pedals. The hinged bonnet and rear engine cover allow full access to a sculpted engine bay that echoes the powerful V‑12 of the original. Externally, the model shines with meticulous attention: sharp LED-style headlights, sculpted intakes and vents, a rear wing, and realistic Lamborghini badging. The finish is glossy and deep, with non-toxic, high-luster paint that adds showroom-level realism. As an officially licensed release from Bburago’s renowned “Collezione” line, it strikes a perfect balance between collector-grade craftsmanship and accessible value. Ideal for enthusiasts and collectors, this Aventador SV model dazzles as a display piece, a hands-on collectible, or a proud tribute to Lamborghini’s bold design legacy.', 30),
('AAT004', 'Model car of Tesla Cybertruck scale 1:18 AutoArt', 1, 6, 125.00, 'The AutoArt 1:18‑scale Tesla Cybertruck is an exceptional composite and die‑cast replica that brings Tesla’s radical electric pickup design into meticulous scale form. Designed using the actual 3D CAD data from Tesla’s Design Studio, it faithfully reproduces the angular stainless‑steel‑style body, spanning approximately 328 mm in length, 125 mm in width, and 103 mm in height—a true 1:18 interpretation. Comprising over 180 metal and plastic components, this model features functional elements such as opening front and rear doors, a magnetic tailgate, removable tonneau cover, steerable wheels, and rubber tires—capturing both the look and feel of the real Cybertruck. The interior is richly detailed with carpeted flooring, fabric seat belts with buckles, fully molded seats, and a center touchscreen display showcasing a map of Cybertruck’s home base—an amusing and immersive Easter egg. Additional highlights include a panoramic glass roof, realistic steering yoke mirroring Tesla’s prototype, and a weighty build of about 1.5 kg, lending the model a substantial, high‑quality presence. Part toy, part precision model, the AutoArt Cybertruck is a standout collectible. Whether displayed in an office, study, or collector’s cabinet, it offers both striking visuals and tactile interaction—a fitting tribute to one of the boldest automotive designs of the decade.', 25),
('GL004', 'Model car of Jeep Grand Cherokee scale 1:64 GreenLight', 1, 7, 10.00, 'The GreenLight 1:64-scale Jeep Grand Cherokee is a finely crafted miniature that delivers both style and substance in a compact package. Measuring about 2¾–3 inches long, this scale model features a sturdy die-cast metal body and chassis, complemented by molded plastic trim and smooth rolling rubber-style tires—capturing the rugged yet refined essence of the real SUV. Its exterior detail pays homage to the Grand Cherokee’s bold presence: a sculpted seven-slot grille, sharp headlights, authentic Jeep badging, and realistic side mirrors. Paint finishes often include deep metallics, glossy blacks, and special-edition liveries, making it stand out on any shelf or desk. The translucent windows offer glimpses of a molded interior, including seats and a dashboard, enhancing its display appeal. Packaged in GreenLight’s collectible blister card, this Grand Cherokee model fits seamlessly alongside other 1:64 series vehicles or Hollywood-themed sets. It’s ideal for collectors, Jeep enthusiasts, or anyone appreciating high-quality miniature craftsmanship. Durable and detailed, it balances display value and playability—perfect for showcasing American off-road heritage in a compact, eye-catching form.', 140),
('KYO004', 'Model car of Mazda MX‑5 Miata scale 1:24 Kyosho', 2, 8, 18.75, 'The Kyosho 1:24-scale Mazda MX‑5 Miata is a finely crafted die‑cast replica that beautifully captures the essence of the beloved roadster. Measuring about 7 inches (18 cm) long, it sports a robust metal body with authentic rubber tires and steerable front wheels, reflecting Kyosho’s commitment to realism. This concise yet detailed model features opening elements including a hinged bonnet and doors, revealing a meticulously sculpted interior—complete with a dashboard, bucket seats, and sculpted trims. The engine bay is also modeled, offering an added layer of authenticity for collectors and Miata fans alike. Its exterior is a standout, typically offered in iconic finishes like British Racing Green with beige interior, classic NA pop-up headlights, realistic side mirrors, and Mazda badging. Collectors particularly praise paint quality: one shared they sourced theirs from a Tokyo event in BRG with removable hardtop and pop-up headlights intact—"incredibly detailed" and cherished for display. Though modestly scaled, the Kyosho Miata offers impressive presence and tactile engagement. Whether it’s a desk display, part of a collection, or a nostalgic gift for an MX‑5 enthusiast, this model stands out for its craftsmanship, authenticity, and clear tribute to the spirit of the iconic roadster.', 55),
('AAT005', 'Model car of Porsche Taycan scale 1:18 AutoArt', 1, 6, 83.29, 'The AUTOart 1:18-scale Porsche Taycan is a premium composite replica that masterfully captures Porsche’s first fully electric luxury sedan, available in variants like the sleek Cross Turismo and Turbo S. Built using ABS and die-cast metal components, the model reflects AUTOart’s precision craftsmanship, faithfully recreated from official CAD data with sharp panel lines and beautiful finishes. Every detail impresses: the model features opening front doors, hood, and tailgate, revealing a meticulously detailed cabin with carpeted flooring, realistic seats, seatbelts, and a fully molded dashboard complete with touchscreen elements reflecting the Taycan’s advanced interior . The paintwork mirrors real-life color options—from glacier white metallic to striking blue—and premium alloys discernibly capture Porsche’s distinct wheel designs. Externally, the Taycan’s signature four‑point LED headlights, smooth aerodynamic curves, and seamless door handles are accurately rendered. Wheels are steerable, and premium rubber tires rest on a model that’s approximately 11 inches long—true to the 1:18 scale standard. AUTOart’s reputation among collectors is solid: praised for craftsmanship, level of detail, and opening features, and considered one of the top-tier brands for 1:18 scale replicas. This Taycan model is a must-have for enthusiasts, blending cutting-edge automotive design with exquisite miniature artistry.', 25),
('MTB004', 'Model car of Ford Bronco scale 1:64 Matchbox', 1, 9, 20.00, 'The Matchbox 1:64-scale Ford Bronco is a compact yet highly detailed die-cast replica that embodies both the vintage charm of the classic Broncos and the rugged spirit of modern off-road icons. Measuring approximately 3 inches in length, this model features a durable metal body and chassis, smooth rubber-style wheels, and meticulous plastic accents—like the seven-slot grille, round headlights, side mirrors, and authentic Bronco badging. Available in a range of striking liveries—from mint green “25/100” anniversary editions and blue main-line releases to National Parks themed pastel hues—this Bronco variation captures collectors’ attention. Many of the latest “Moving Parts” releases even include functioning doors and hoods, adding playability and display value. Reddit collectors say the casting is next-level: “Matchbox is always more realistic…so much more realistic IMO.”, “The only problem is the hood does not stay up,” but still major praise.”.  Overall, this Matchbox Bronco stands out for its faithful proportions, robust build, and collectible appeal. Whether displayed on a shelf, used in miniature dioramas, or slid across a desk, it encapsulates the adventurous Bronco essence in a pocket-sized package. A perfect gift for car lovers or a standout addition for any 1:64 enthusiast.', 160),
('HW005', 'Model car of Mercedes‑AMG GT scale 1:24 Hot Wheels', 2, 2, 29.17, 'The Hot Wheels Mercedes‑AMG GT 1:24 model is an impressive, larger-scale rendition of the iconic German supercar. With a robust metal body and chassis, along with rubber-style rolling wheels, this model delivers both heft and realism—appreciated by collectors seeking display‑worthy detail beyond the typical 1:64 offerings. Released in the Exotics or Premium “Real Riders” series, its paint finish stands out—often seen in vibrant reds, yellows, and oranges, complete with glossy flake and crisp racing decals. Many users on forums highlight its “gorgeous” appearance and step-up craftsmanship compared to smaller mainline castings . One buyer noted how the high-quality spectra-flame paint “shines in all light,” with detailed headlights and taillights adding to its realism. Collectors praise the larger scale for showcasing sculpted curves, precise grille lines, and AMG insignias that smaller versions can’t capture. As one preview comment put it: “Hot Wheels is always more realistic… so much more realistic IMO,” even if some castings have minor issues like loose hoods. Overall, the Hot Wheels 1:24 AMG GT balances collectible appeal with affordability—ideal for enthusiasts who want a standout representation of Mercedes‑AMG is sleek, performance‑driven design.', 45),
('MST005', 'Model car of Acura NSX scale 1:24 Maisto', 2, 4, 45.83, 'The Maisto 1:24-scale Acura NSX is a beautifully detailed replica of the 2018 hybrid supercar, blending authenticity with affordability. Measuring approximately 7.25" × 3.5" × 2", it features a die-cast metal body, chassis, plastic accents, and rubber tires—true to Maisto is Special Edition line. This replica offers free-wheel action and opening front doors (and sometimes the hood), allowing a clear view of its refined interior—complete with dashboard, seats, steering wheel—and engine bay detail housed beneath the bonnet. The scale and proportions are accurate to the real NSX, capturing its sleek mid-engine stance in a compact format. Available in striking colorways like red or blue top, each model arrives boxed and display-ready. The real-rubber tires and precise paintwork add collector appeal, while the working components boost playability. As part of Maisto’s globally respected die-cast line—manufactured under May Cheong—it combines licensed design detail with solid value. For fans of the NSX or die-cast collectors, this model delivers a balanced blend of visual fidelity, interactive features, and pocket-sized charm.', 40),
('HW006', 'Model car of Corvette Stingray scale 1:64 Hot Wheels', 1, 2, 11.25, 'The Hot Wheels 1:64-scale Corvette Stingray captures the iconic sports car in a compact, collectible package. Measuring roughly 3 inches long, it features a metal body and chassis, plastic accents, and smooth-rolling wheels—ideal for both display and play. Several generations of the Stingray have been released in Hot Wheels’ mainline and premium “Car Culture” or “HW Showroom” series. Standout versions include the "64 Corvette Sting Ray with period-correct body lines and rear-window styling, often adorned in metallic silver, deep green, classic white, fiery red, or light blue, many sporting racing stripes or roundel graphics. Higher-tier releases may include rubber tires and two-piece metal-metal chassis for improved realism and heft. Collectors praise the casting quality for its accurate sculpting: “detailed headlights, taillights, trim and badging” consistently match the full-size Corvette’s signature look. Even entry-level blister-card models offer striking paint—such as black stripe accents on silver bodies—delighting fans and fitting well within broader Hot Wheels collections. Overall, this 1:64 Stingray balances showworthy detail with affordability. Whether you are a Corvette enthusiast, Hot Wheels hobbyist, or nostalgic collector, it is a standout piece that brings the legend of the Stingray into a fun, pocket-sized form.', 170),
('AAT006', 'Model car of Rolls‑Royce Phantom scale 1:18 AutoArt', 1, 6, 125.00, 'The AUTOart 1:18‑scale Rolls‑Royce Phantom is a prestige-grade replica that impeccably captures the elegance of Britain’s flagship luxury sedan. Crafted using a composite of finely detailed ABS plastic and die-cast metal—based on official CAD data from Rolls‑Royce—the model showcases razor-sharp panel lines, a faithful rendition of the Spirit of Ecstasy emblem, and iconic Pantheon grille. Measuring roughly 11 inches in length, this collectible features fully functional front doors, hood, and trunk lid, each opening to reveal a beautifully appointed interior. Inside, you will find plush carpeted flooring, seat belts, intricate dashboard instrumentation, and luxurious seat textures—elevating it beyond a mere display piece . The engine compartment houses a convincingly detailed V12 block replica, visible when the hood is lifted. Externally, the model is finished in premium paints—glossy black with dual-tone roof options (silver/grey)—and authentic chrome trim around the grille, window surrounds, mirrors, and wheels. Steerable front wheels and soft rubber tires add realism to its presence. AUTOart, a Hong Kong-based manufacturer known for accuracy and craftsmanship, consistently delivers full-featured models—with carpet, seatbelts, opening parts, and detailed lighting—making it a top-tier brand for collectors seeking quality and elegance. In essence, this Phantom model exudes luxury in miniature form—an exquisite showpiece that reflects the grandeur of the full-scale Rolls‑Royce for display in any discerning collector’s cabinet.', 15),
('TMC004', 'Model car of Subaru Outback scale 1:64 Tomica', 1, 5, 14.58, 'The Tomica 1:64-scale Subaru Outback is a charming and well-detailed die-cast replica from Takara Tomy’s popular lineup. Measuring approximately 3 inches long, it features a solid metal body and chassis, crisp plastic trim, and smooth-rolling wheels—ideal for collectors who appreciate miniature realism without sacrificing play value. Though Outback castings are rare—especially compared to more common Foresters and Imprezas—the model was issued as a dealer-exclusive in several regions. As one Redditor shared: “The major brands do not make an Outback, but there IS a Subaru dealer‑exclusive line of 1:64 diecast, including an Outback.”. The miniature captures the Outback’s signature crossover silhouette, distinct roof rails, and rugged wagon stance. Paint finishes vary; popular dealer editions include deep green, white, and gray variants inspired by real-world trims like the Wilderness . While standard Tomica and Premium lines may not strictly adhere to 1:64 scale, this special model still offers excellent collector appeal. Though it lacks opening parts, this is compensated by its sturdy feel and accuracy in detailing—from the grille and headlight profile to the embossed side trims. Perfect for desk displays, dioramas, or adding a Subaru-themed piece to your collection, the Tomica Subaru Outback brings a touch of adventure and Japanese automotive charm in a compact, pocket-friendly form.', 130);

INSERT INTO imageModel (imageId, modelId, imageUrl, caption) VALUES
('MGT002_01', 'MGT002', 'assets/img/MGT002/1.jpg', 'Toyota Supra A90'),
('MGT002_02', 'MGT002', 'assets/img/MGT002/2.jpg', 'Toyota Supra A90'),
('MGT002_03', 'MGT002', 'assets/img/MGT002/3.jpg', 'Toyota Supra A90'),
('MGT002_04', 'MGT002', 'assets/img/MGT002/4.jpg', 'Toyota Supra A90'),
('HW002_01', 'HW002', 'assets/img/HW002/1.jpg', 'Ford Mustang GT'),
('HW002_02', 'HW002', 'assets/img/HW002/2.jpg', 'Ford Mustang GT'),
('HW002_03', 'HW002', 'assets/img/HW002/3.jpg', 'Ford Mustang GT'),
('HW002_04', 'HW002', 'assets/img/HW002/4.jpg', 'Ford Mustang GT'),
('BBR002_01', 'BBR002', 'assets/img/BBR002/1.jpg', 'Lamborghini Huracán EVO'),
('BBR002_02', 'BBR002', 'assets/img/BBR002/2.jpg', 'Lamborghini Huracán EVO'),
('BBR002_03', 'BBR002', 'assets/img/BBR002/3.jpg', 'Lamborghini Huracán EVO'),
('BBR002_04', 'BBR002', 'assets/img/BBR002/4.jpg', 'Lamborghini Huracán EVO'),
('MST001_01', 'MST001', 'assets/img/MST001/1.jpg', 'Chevrolet Camaro ZL1'),
('MST001_02', 'MST001', 'assets/img/MST001/2.jpg', 'Chevrolet Camaro ZL1'),
('MST001_03', 'MST001', 'assets/img/MST001/3.jpg', 'Chevrolet Camaro ZL1'),
('MST001_04', 'MST001', 'assets/img/MST001/4.jpg', 'Chevrolet Camaro ZL1'),
('TMC001_01', 'TMC001', 'assets/img/TMC001/1.jpg', 'Nissan Fairlady Z'),
('TMC001_02', 'TMC001', 'assets/img/TMC001/2.jpg', 'Nissan Fairlady Z'),
('TMC001_03', 'TMC001', 'assets/img/TMC001/3.jpg', 'Nissan Fairlady Z'),
('TMC001_04', 'TMC001', 'assets/img/TMC001/4.jpg', 'Nissan Fairlady Z'),
('AAT001_01', 'AAT001', 'assets/img/AAT001/1.jpg', 'Porsche 911 GT3 RS'),
('AAT001_02', 'AAT001', 'assets/img/AAT001/2.jpg', 'Porsche 911 GT3 RS'),
('AAT001_03', 'AAT001', 'assets/img/AAT001/3.jpg', 'Porsche 911 GT3 RS'),
('AAT001_04', 'AAT001', 'assets/img/AAT001/4.jpg', 'Porsche 911 GT3 RS'),
('GL001_01', 'GL001', 'assets/img/GL001/1.jpg', 'Dodge Charger R/T'),
('GL001_02', 'GL001', 'assets/img/GL001/2.jpg', 'Dodge Charger R/T'),
('GL001_03', 'GL001', 'assets/img/GL001/3.jpg', 'Dodge Charger R/T'),
('GL001_04', 'GL001', 'assets/img/GL001/4.jpg', 'Dodge Charger R/T'),
('KYO001_01', 'KYO001', 'assets/img/KYO001/1.jpg', 'Mazda RX-7 FD3S'),
('KYO001_02', 'KYO001', 'assets/img/KYO001/2.jpg', 'Mazda RX-7 FD3S'),
('KYO001_03', 'KYO001', 'assets/img/KYO001/3.jpg', 'Mazda RX-7 FD3S'),
('KYO001_04', 'KYO001', 'assets/img/KYO001/4.jpg', 'Mazda RX-7 FD3S'),
('MTB001_01', 'MTB001', 'assets/img/MTB001/1.jpg', 'Volkswagen Beetle'),
('MTB001_02', 'MTB001', 'assets/img/MTB001/2.jpg', 'Volkswagen Beetle'),
('MTB001_03', 'MTB001', 'assets/img/MTB001/3.jpg', 'Volkswagen Beetle'),
('MTB001_04', 'MTB001', 'assets/img/MTB001/4.jpg', 'Volkswagen Beetle'),
('WLY001_01', 'WLY001', 'assets/img/WLY001/1.jpg', 'BMW M3 E30'),
('WLY001_02', 'WLY001', 'assets/img/WLY001/2.jpg', 'BMW M3 E30'),
('WLY001_03', 'WLY001', 'assets/img/WLY001/3.jpg', 'BMW M3 E30'),
('WLY001_04', 'WLY001', 'assets/img/WLY001/4.jpg', 'BMW M3 E30'),
('MGT003_01', 'MGT003', 'assets/img/MGT003/1.jpg', 'Honda Civic Type R FK8'),
('MGT003_02', 'MGT003', 'assets/img/MGT003/2.jpg', 'Honda Civic Type R FK8'),
('MGT003_03', 'MGT003', 'assets/img/MGT003/3.jpg', 'Honda Civic Type R FK8'),
('MGT003_04', 'MGT003', 'assets/img/MGT003/4.jpg', 'Honda Civic Type R FK8'),
('HW003_01', 'HW003', 'assets/img/HW003/1.jpg', 'Tesla Model S'),
('HW003_02', 'HW003', 'assets/img/HW003/2.jpg', 'Tesla Model S'),
('HW003_03', 'HW003', 'assets/img/HW003/3.jpg', 'Tesla Model S'),
('HW003_04', 'HW003', 'assets/img/HW003/4.jpg', 'Tesla Model S'),
('BBR003_01', 'BBR003', 'assets/img/BBR003/1.jpg', 'Ferrari 488 GTB'),
('BBR003_02', 'BBR003', 'assets/img/BBR003/2.jpg', 'Ferrari 488 GTB'),
('BBR003_03', 'BBR003', 'assets/img/BBR003/3.jpg', 'Ferrari 488 GTB'),
('BBR003_04', 'BBR003', 'assets/img/BBR003/4.jpg', 'Ferrari 488 GTB'),
('MST002_01', 'MST002', 'assets/img/MST002/1.jpg', 'Jeep Wrangler Rubicon'),
('MST002_02', 'MST002', 'assets/img/MST002/2.jpg', 'Jeep Wrangler Rubicon'),
('MST002_03', 'MST002', 'assets/img/MST002/3.jpg', 'Jeep Wrangler Rubicon'),
('MST002_04', 'MST002', 'assets/img/MST002/4.jpg', 'Jeep Wrangler Rubicon'),
('TMC002_01', 'TMC002', 'assets/img/TMC002/1.jpg', 'Suzuki Jimny'),
('TMC002_02', 'TMC002', 'assets/img/TMC002/2.jpg', 'Suzuki Jimny'),
('TMC002_03', 'TMC002', 'assets/img/TMC002/3.jpg', 'Suzuki Jimny'),
('TMC002_04', 'TMC002', 'assets/img/TMC002/4.jpg', 'Suzuki Jimny'),
('AAT002_01', 'AAT002', 'assets/img/AAT002/1.jpg', 'McLaren P1'),
('AAT002_02', 'AAT002', 'assets/img/AAT002/2.jpg', 'McLaren P1'),
('AAT002_03', 'AAT002', 'assets/img/AAT002/3.jpg', 'McLaren P1'),
('AAT002_04', 'AAT002', 'assets/img/AAT002/4.jpg', 'McLaren P1'),
('GL002_01', 'GL002', 'assets/img/GL002/1.jpg', 'Chevrolet Impala SS'),
('GL002_02', 'GL002', 'assets/img/GL002/2.jpg', 'Chevrolet Impala SS'),
('GL002_03', 'GL002', 'assets/img/GL002/3.jpg', 'Chevrolet Impala SS'),
('GL002_04', 'GL002', 'assets/img/GL002/4.jpg', 'Chevrolet Impala SS'),
('KYO002_01', 'KYO002', 'assets/img/KYO002/1.jpg', 'Subaru Impreza WRX STI'),
('KYO002_02', 'KYO002', 'assets/img/KYO002/2.jpg', 'Subaru Impreza WRX STI'),
('KYO002_03', 'KYO002', 'assets/img/KYO002/3.jpg', 'Subaru Impreza WRX STI'),
('KYO002_04', 'KYO002', 'assets/img/KYO002/4.jpg', 'Subaru Impreza WRX STI'),
('MTB002_01', 'MTB002', 'assets/img/MTB002/1.jpg', 'Land Rover Defender 90'),
('MTB002_02', 'MTB002', 'assets/img/MTB002/2.jpg', 'Land Rover Defender 90'),
('MTB002_03', 'MTB002', 'assets/img/MTB002/3.jpg', 'Land Rover Defender 90'),
('MTB002_04', 'MTB002', 'assets/img/MTB002/4.jpg', 'Land Rover Defender 90'),
('WLY002_01', 'WLY002', 'assets/img/WLY002/1.jpg', 'Audi R8 V10 Plus'),
('WLY002_02', 'WLY002', 'assets/img/WLY002/2.jpg', 'Audi R8 V10 Plus'),
('WLY002_03', 'WLY002', 'assets/img/WLY002/3.jpg', 'Audi R8 V10 Plus'),
('WLY002_04', 'WLY002', 'assets/img/WLY002/4.jpg', 'Audi R8 V10 Plus'),
('BBR004_01', 'BBR004', 'assets/img/BBR004/1.jpg', 'Alfa Romeo Giulia'),
('BBR004_02', 'BBR004', 'assets/img/BBR004/2.jpg', 'Alfa Romeo Giulia'),
('BBR004_03', 'BBR004', 'assets/img/BBR004/3.jpg', 'Alfa Romeo Giulia'),
('BBR004_04', 'BBR004', 'assets/img/BBR004/4.jpg', 'Alfa Romeo Giulia'),
('MST003_01', 'MST003', 'assets/img/MST003/1.jpg', 'Mercedes‑Benz G‑Class'),
('MST003_02', 'MST003', 'assets/img/MST003/2.jpg', 'Mercedes‑Benz G‑Class'),
('MST003_03', 'MST003', 'assets/img/MST003/3.jpg', 'Mercedes‑Benz G‑Class'),
('MST003_04', 'MST003', 'assets/img/MST003/4.jpg', 'Mercedes‑Benz G‑Class'),
('HW004_01', 'HW004', 'assets/img/HW004/1.jpg', 'Ford F‑150 Raptor'),
('HW004_02', 'HW004', 'assets/img/HW004/2.jpg', 'Ford F‑150 Raptor'),
('HW004_03', 'HW004', 'assets/img/HW004/3.jpg', 'Ford F‑150 Raptor'),
('HW004_04', 'HW004', 'assets/img/HW004/4.jpg', 'Ford F‑150 Raptor'),
('GL003_01', 'GL003', 'assets/img/GL003/1.jpg', 'Corvette C8'),
('GL003_02', 'GL003', 'assets/img/GL003/2.jpg', 'Corvette C8'),
('GL003_03', 'GL003', 'assets/img/GL003/3.jpg', 'Corvette C8'),
('GL003_04', 'GL003', 'assets/img/GL003/4.jpg', 'Corvette C8'),
('KYO003_01', 'KYO003', 'assets/img/KYO003/1.jpg', 'Nissan GT‑R R35'),
('KYO003_02', 'KYO003', 'assets/img/KYO003/2.jpg', 'Nissan GT‑R R35'),
('KYO003_03', 'KYO003', 'assets/img/KYO003/3.jpg', 'Nissan GT‑R R35'),
('KYO003_04', 'KYO003', 'assets/img/KYO003/4.jpg', 'Nissan GT‑R R35'),
('AAT003_01', 'AAT003', 'assets/img/AAT003/1.jpg', 'BMW i8'),
('AAT003_02', 'AAT003', 'assets/img/AAT003/2.jpg', 'BMW i8'),
('AAT003_03', 'AAT003', 'assets/img/AAT003/3.jpg', 'BMW i8'),
('AAT003_04', 'AAT003', 'assets/img/AAT003/4.jpg', 'BMW i8'),
('MTB003_01', 'MTB003', 'assets/img/MTB003/1.jpg', 'Volkswagen Golf GTI'),
('MTB003_02', 'MTB003', 'assets/img/MTB003/2.jpg', 'Volkswagen Golf GTI'),
('MTB003_03', 'MTB003', 'assets/img/MTB003/3.jpg', 'Volkswagen Golf GTI'),
('MTB003_04', 'MTB003', 'assets/img/MTB003/4.jpg', 'Volkswagen Golf GTI'),
('MST004_01', 'MST004', 'assets/img/MST004/1.jpg', 'Dodge Viper ACR'),
('MST004_02', 'MST004', 'assets/img/MST004/2.jpg', 'Dodge Viper ACR'),
('MST004_03', 'MST004', 'assets/img/MST004/3.jpg', 'Dodge Viper ACR'),
('MST004_04', 'MST004', 'assets/img/MST004/4.jpg', 'Dodge Viper ACR'),
('TMC003_01', 'TMC003', 'assets/img/TMC003/1.jpg', 'Subaru BRZ'),
('TMC003_02', 'TMC003', 'assets/img/TMC003/2.jpg', 'Subaru BRZ'),
('TMC003_03', 'TMC003', 'assets/img/TMC003/3.jpg', 'Subaru BRZ'),
('TMC003_04', 'TMC003', 'assets/img/TMC003/4.jpg', 'Subaru BRZ'),
('BBR005_01', 'BBR005', 'assets/img/BBR005/1.jpg', 'Lamborghini Aventador'),
('BBR005_02', 'BBR005', 'assets/img/BBR005/2.jpg', 'Lamborghini Aventador'),
('BBR005_03', 'BBR005', 'assets/img/BBR005/3.jpg', 'Lamborghini Aventador'),
('BBR005_04', 'BBR005', 'assets/img/BBR005/4.jpg', 'Lamborghini Aventador'),
('AAT004_01', 'AAT004', 'assets/img/AAT004/1.jpg', 'Tesla Cybertruck'),
('AAT004_02', 'AAT004', 'assets/img/AAT004/2.jpg', 'Tesla Cybertruck'),
('AAT004_03', 'AAT004', 'assets/img/AAT004/3.jpg', 'Tesla Cybertruck'),
('AAT004_04', 'AAT004', 'assets/img/AAT004/4.jpg', 'Tesla Cybertruck'),
('GL004_01', 'GL004', 'assets/img/GL004/1.jpg', 'Jeep Grand Cherokee'),
('GL004_02', 'GL004', 'assets/img/GL004/2.jpg', 'Jeep Grand Cherokee'),
('GL004_03', 'GL004', 'assets/img/GL004/3.jpg', 'Jeep Grand Cherokee'),
('GL004_04', 'GL004', 'assets/img/GL004/4.jpg', 'Jeep Grand Cherokee'),
('KYO004_01', 'KYO004', 'assets/img/KYO004/1.jpg', 'Mazda MX‑5 Miata'),
('KYO004_02', 'KYO004', 'assets/img/KYO004/2.jpg', 'Mazda MX‑5 Miata'),
('KYO004_03', 'KYO004', 'assets/img/KYO004/3.jpg', 'Mazda MX‑5 Miata'),
('KYO004_04', 'KYO004', 'assets/img/KYO004/4.jpg', 'Mazda MX‑5 Miata'),
('AAT005_01', 'AAT005', 'assets/img/AAT005/1.jpg', 'Porsche Taycan'),
('AAT005_02', 'AAT005', 'assets/img/AAT005/2.jpg', 'Porsche Taycan'),
('AAT005_03', 'AAT005', 'assets/img/AAT005/3.jpg', 'Porsche Taycan'),
('AAT005_04', 'AAT005', 'assets/img/AAT005/4.jpg', 'Porsche Taycan'),
('MTB004_01', 'MTB004', 'assets/img/MTB004/1.jpg', 'Ford Bronco'),
('MTB004_02', 'MTB004', 'assets/img/MTB004/2.jpg', 'Ford Bronco'),
('MTB004_03', 'MTB004', 'assets/img/MTB004/3.jpg', 'Ford Bronco'),
('MTB004_04', 'MTB004', 'assets/img/MTB004/4.jpg', 'Ford Bronco'),
('HW005_01', 'AAT005', 'assets/img/AAT005/1.jpg', 'Mercedes‑AMG GT'),
('HW005_02', 'HW005', 'assets/img/AAT005/2.jpg', 'Mercedes‑AMG GT'),
('HW005_03', 'HW005', 'assets/img/AAT005/3.jpg', 'Mercedes‑AMG GT'),
('HW005_04', 'HW005', 'assets/img/AAT005/4.jpg', 'Mercedes‑AMG GT'),
('MST005_01', 'MST005', 'assets/img/MST005/1.jpg', 'Acura NSX'),
('MST005_02', 'MST005', 'assets/img/MST005/2.jpg', 'Acura NSX'),
('MST005_03', 'MST005', 'assets/img/MST005/3.jpg', 'Acura NSX'),
('MST005_04', 'MST005', 'assets/img/MST005/4.jpg', 'Acura NSX'),
('HW006_01', 'HW006', 'assets/img/HW005/1.jpg', 'Corvette Stingray'),
('HW006_02', 'HW006', 'assets/img/HW005/2.jpg', 'Corvette Stingray'),
('HW006_03', 'HW006', 'assets/img/HW005/3.jpg', 'Corvette Stingray'),
('HW006_04', 'HW006', 'assets/img/HW005/4.jpg', 'Corvette Stingray'),
('AAT006_01', 'AAT006', 'assets/img/AAT006/1.jpg', 'Rolls‑Royce Phantom'),
('AAT006_02', 'AAT006', 'assets/img/AAT006/2.jpg', 'Rolls‑Royce Phantom'),
('AAT006_03', 'AAT006', 'assets/img/AAT006/3.jpg', 'Rolls‑Royce Phantom'),
('AAT006_04', 'AAT006', 'assets/img/AAT006/4.jpg', 'Rolls‑Royce Phantom'),
('TMC004_01', 'TMC004', 'assets/img/TMC004/1.jpg', 'Subaru Outback'),
('TMC004_02', 'TMC004', 'assets/img/TMC004/2.jpg', 'Subaru Outback'),
('TMC004_03', 'TMC004', 'assets/img/TMC004/3.jpg', 'Subaru Outback'),
('TMC004_04', 'TMC004', 'assets/img/TMC004/4.jpg', 'Subaru Outback');


INSERT INTO accessory (accessoryId, accessoryName, detail, price, quantity, imageUrl) VALUES
('ACS001', 'Carbon Fiber Spoiler', 'This lightweight carbon fiber spoiler is designed to enhance both the aerodynamic performance and visual appeal of your model car. Crafted with precision from high-quality carbon fiber materials, it offers a realistic racing look while improving stability and downforce in scaled simulations. Ideal for collectors and enthusiasts aiming to customize their models with professional-grade accessories, the spoiler fits most 1:24 and 1:18 scale models and adds a sleek, sporty finish to any display.', 29.99, 15, 'assets/img/ACS/ACS001.jpg'),
('ACS002', 'LED Headlights Kit', 'These bright white LED headlights are specially designed for 1:24 scale model cars, adding a realistic and dynamic lighting effect to your collection. Featuring energy-efficient micro-LED technology, they are easy to install and provide consistent illumination without overheating. Ideal for night-scene displays or enhancing model realism, these headlights bring your miniature vehicles to life, making them perfect for hobbyists seeking professional-grade upgrades.', 15.50, 30, 'assets/img/ACS/ACS002.jpg'),
('ACS003', 'Racing Decal Pack', 'This premium-quality decal pack is perfect for customizing your model cars with a professional racing look. It includes a variety of vibrant racing stripes, sponsor logos, and numbered sets to match popular race styles. Made from durable, easy-to-apply adhesive material, these decals adhere smoothly to most plastic surfaces without bubbling or peeling. Whether you are restoring a classic or building a custom racer, this set adds personality and realism to every model.', 7.25, 50, 'assets/img/ACS/ACS003.jpg'),
('ACS004', 'Miniature Tool Set', 'This precision-crafted miniature tool set is an ideal addition to any detailed model car display or diorama. The set includes a realistic jack, wrench, and tire iron—all designed to scale with fine metallic finishes. Perfect for enhancing garage scenes or pit stop displays, each tool adds authenticity and charm. Whether you are a collector or hobbyist, these accessories bring a touch of realism and storytelling to your model environment.', 12.00, 20, 'assets/img/ACS/ACS004.jpg'),
('ACS005', 'Model Display Case', 'This clear acrylic display case is designed to elegantly showcase and protect your prized model cars from dust, fingerprints, and damage. Featuring a durable transparent enclosure and a sleek black base, it provides a professional presentation while maintaining visibility from all angles. Ideal for collectors who value preservation and aesthetics, the case fits most 1:24 or 1:18 scale models and is a perfect finishing touch for any display shelf or exhibition setup.', 18.75, 10, 'assets/img/ACS/ACS005.jpg');


CREATE TRIGGER TR_customer_cart_updated_at
ON customer_cart
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE customer_cart 
    SET updated_at = GETDATE()
    FROM customer_cart cc
    INNER JOIN inserted i ON cc.id = i.id;
END;

select *from modelCar

select *from imageModel

select*from customer

select*from customerAccount

select *from brandModel

select *from home_gallery

select *from accessory
select *from reset_tokens

CREATE TABLE reset_tokens (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customerId VARCHAR(50) NOT NULL,
    token VARCHAR(255) NOT NULL,
    expiry DATETIME NOT NULL,
    used BIT DEFAULT 0,
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
);