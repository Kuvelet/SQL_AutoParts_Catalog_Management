# SQL_AutoParts_Catalog_Management

## Project Overview

This project is a complete, SQL-based aftermarket auto parts catalog system developed for both internal operations and external distribution. Designed in full alignment with **ACES and PIES** data standards, it transforms raw vehicle fitment and part data into two key outputs:

- A structured **Buyers Guide** covering precise vehicle-part application mapping

- A comprehensive **MasterCross**, which unifies OEM and aftermarket competitor part numbers for each part

I built this system to replace my company’s fragmented and manually maintained catalog with a **fully autonomous, scalable solution**. It enables structured updates using raw input tables maintained by the R&D team—streamlining the integration of new part introductions, vehicle fitments, and cross-reference relationships.

As a result, the catalog’s **accuracy improved, manual workload decreased**, and **data sharing with sales teams and customers became significantly faster and more reliable.**

---

## Tech Stack

- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- ACES / PIES Data Format

The solution is fully database-native, requiring no external tools or languages to operate or maintain the catalog pipeline.

---

## Dataset Description

###  In-Depth Breakdown of Dataset Components

The dataset for this project consists of two distinct yet interconnected components: the foundational **AAIA ACES/PIES** data, and company-specific catalog data. Each serves a unique purpose in creating a comprehensive automotive parts catalog.

---

#### 🔹 1. AAIA ACES/PIES Data (Industry Standard)

The Automotive Aftermarket Industry Association (**AAIA**) provides standardized vehicle fitment and application data using the **ACES (Aftermarket Catalog Exchange Standard)** and **PIES (Product Information Exchange Standard)** frameworks. This foundational dataset includes:

- **Vehicle Identification and Attributes**  
  `Make`, `Model`, `Year`, `SubModel`, `BodyType`, `VehicleType`, `BodyNumDoors`, `DriveTypeName`, etc.

- **Engine and Performance Data**  
  `EngineBaseID`, `Liter`, `Cylinders`, `AspirationName`, `FuelTypeName`

- **Technical Specifications**  
  `TransmissionControlTypeName`, `SteeringSystemName`, `BrakeABSName`, `CylinderHeadTypeName`

This data ensures industry-wide consistency and compatibility, forming the base upon which the catalog is structured.

---

#### 🔸 2. Company-Specific Catalog Data (Internally Generated)

On top of the ACES/PIES structure, I’ve augmented the dataset with company-specific part information tailored for our internal catalog system. This includes:

- **Product Identification**  
  `TSPARTID`, `TSPARTIDLR`, `AAIAPARTTERMINOLOGY`, `AAIAPOSITION`

- **Inventory and Localization**  
  `QUANTITY`, `MEXICO`, `CanK`

- **Fitment and Interchangeability Details**  
  `Opposite_Side_PARTID`, `Submodel_RockAuto`, `COMMENTS`, `DETAILS`

These fields provide the detailed part-level resolution needed to drive accurate Buyers Guide generation and SKU-to-vehicle mapping.

---

#### 🎯 Why Combine AAIA and Company Data?

Merging these two data sources enables a powerful, dual-purpose catalog system:

- **Industry Alignment**  
  Maintains compatibility with external systems, buyers, and data-sharing partners using the AAIA standard.

- **Operational Precision**  
  Enhances internal accuracy in product mapping, inventory alignment, and vehicle fitment validation.

This hybrid dataset design lays the foundation for a scalable, autonomous, and high-integrity catalog system purpose-built for real-world use.

---


**Sample ACES/PIES Data (1991 Nissan Pathfinder Example):**

| RegionID | Make | Model | Year | SubModel | VehicleType | FuelTypeName | DriveTypeName | TransmissionControlTypeName | BodyType | BodyNumDoors | BaseVehicleID | AspirationName | EngineBaseID | Liter | CC | CID | Cylinders | BlockType | SteeringSystemName | SteeringTypeName | VehicleID | BodyTypeID | BodyNumDoorsID | DriveTypeID | BrakeABSName | CylinderHeadTypeName |
|----------|------|-------|------|----------|-------------|--------------|---------------|-----------------------------|----------|--------------|---------------|----------------|--------------|-------|----|-----|-----------|-----------|--------------------|------------------|-----------|------------|----------------|-------------|--------------|----------------------|
| 1 | Nissan | Pathfinder | 1991 | SE | Truck | GAS | 4WD | Automatic | Sport Utility | 4 | 12345 | Naturally Aspirated | 678 | 3.0 | 2960 | 181 | 6 | V | Power | Rack & Pinion | 54321 | 5 | 4 | 4 | 4-Wheel ABS | SOHC |

> The sample data has been anonymized and simplified for demonstration purposes only.
Building upon the ACES/PIES structure, I've integrated our company's specific part number information to generate our comprehensive raw catalog dataset. This augmented dataset is the cornerstone for the final catalog generation.

**Example of Our Augmented Raw Catalog Data (1991 Nissan Pathfinder Example):**

| MAKE | MODEL | BodyType | Year | SUBMODEL | VehicleType | BodyNumDoors | MfrBodyCode | YrMax | COMMENTS | DETAILS | AAIAPARTTERMINOLOGY | AAIAPOSITION | QUANTITY | TSPARTID | TSPARTIDLR | MEXICO | Liter | Cylinders | AspirationName | FuelTypeName | DriveTypeName | Submodel_RockAuto | CanK | Opposite_Side_PARTID |
|------|-------|----------|------|----------|-------------|--------------|-------------|-------|----------|---------|--------------------|--------------|----------|----------|------------|--------|-------|-----------|----------------|--------------|---------------|-------------------|------|----------------------|
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Liftgate Lift Support | NULL | 2 | 611321 | 611321 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | NULL |
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Back Glass Lift Support | Left | 1 | 612921 | 612921 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | 612917 |
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Back Glass Lift Support | Right | 1 | 612917 | 612917 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | 612921 |

> The sample data has been anonymized and simplified for demonstration purposes only.
This enhanced dataset forms the backbone of the system—supporting precise vehicle fitment logic, structured catalog assembly, and rich Buyers Guide generation.







