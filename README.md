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

The foundational dataset for this project leverages the **ACES and PIES data standards**, the industry-leading formats established by the Automotive Aftermarket Industry Association (AAIA). These standardized formats are universally used across the automotive sector to reliably exchange vehicle and part fitment data.

**Sample ACES/PIES Data (1991 Nissan Pathfinder Example):**

| RegionID | Make | Model | Year | SubModel | VehicleType | FuelTypeName | DriveTypeName | TransmissionControlTypeName | BodyType | BodyNumDoors | BaseVehicleID | AspirationName | EngineBaseID | Liter | CC | CID | Cylinders | BlockType | SteeringSystemName | SteeringTypeName | VehicleID | BodyTypeID | BodyNumDoorsID | DriveTypeID | BrakeABSName | CylinderHeadTypeName |
|----------|------|-------|------|----------|-------------|--------------|---------------|-----------------------------|----------|--------------|---------------|----------------|--------------|-------|----|-----|-----------|-----------|--------------------|------------------|-----------|------------|----------------|-------------|--------------|----------------------|
| 1 | Nissan | Pathfinder | 1991 | SE | Truck | GAS | 4WD | Automatic | Sport Utility | 4 | 12345 | Naturally Aspirated | 678 | 3.0 | 2960 | 181 | 6 | V | Power | Rack & Pinion | 54321 | 5 | 4 | 4 | 4-Wheel ABS | SOHC |

Building upon the ACES/PIES structure, I've integrated our company's specific part number information to generate our comprehensive raw catalog dataset. This augmented dataset is the cornerstone for the final catalog generation.

**Example of Our Augmented Raw Catalog Data (1991 Nissan Pathfinder Example):**

| MAKE | MODEL | BodyType | Year | SUBMODEL | VehicleType | BodyNumDoors | MfrBodyCode | YrMax | COMMENTS | DETAILS | AAIAPARTTERMINOLOGY | AAIAPOSITION | QUANTITY | TSPARTID | TSPARTIDLR | MEXICO | Liter | Cylinders | AspirationName | FuelTypeName | DriveTypeName | Submodel_RockAuto | CanK | Opposite_Side_PARTID |
|------|-------|----------|------|----------|-------------|--------------|-------------|-------|----------|---------|--------------------|--------------|----------|----------|------------|--------|-------|-----------|----------------|--------------|---------------|-------------------|------|----------------------|
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Liftgate Lift Support | NULL | 2 | 611321 | 611321 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | NULL |
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Back Glass Lift Support | Left | 1 | 612921 | 612921 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | 612917 |
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Back Glass Lift Support | Right | 1 | 612917 | 612917 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | 612921 |

This enhanced dataset serves as the foundation for clearly defining vehicle fitment, facilitating accurate catalog structuring and detailed buyer guide generation.







