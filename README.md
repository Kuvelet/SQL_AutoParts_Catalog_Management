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

This project’s catalog system is built on a unified dataset combining two key sources: **industry-standard AAIA ACES/PIES data** and **company-specific part data**. Together, they deliver both compatibility with external systems and the detailed resolution required for precise internal catalog management.

### Data Sources

- **AAIA ACES/PIES Data (Industry Standard):**  
  The Automotive Aftermarket Industry Association (AAIA) provides the ACES (Aftermarket Catalog Exchange Standard) and PIES (Product Information Exchange Standard) formats. These cover essential fitment attributes such as:
    - Vehicle details: `Make`, `Model`, `Year`, `SubModel`, `BodyType`, `VehicleType`, `BodyNumDoors`, `DriveTypeName`
    - Engine & performance: `EngineBaseID`, `Liter`, `Cylinders`, `AspirationName`, `FuelTypeName`
    - Technical specs: `TransmissionControlTypeName`, `SteeringSystemName`, `BrakeABSName`, `CylinderHeadTypeName`
  This ensures the catalog is consistent, widely compatible, and easy to integrate with industry partners.

- **Company-Specific Data:**  
  To enhance the ACES/PIES foundation, additional fields are included for internal needs, such as:
    - Product identification: `TSPARTID`, `TSPARTIDLR`, `AAIAPARTTERMINOLOGY`, `AAIAPOSITION`
    - Inventory/localization: `QUANTITY`, `MEXICO`, `CanK`
    - Fitment/interchangeability: `Opposite_Side_PARTID`, `Submodel_RockAuto`, `COMMENTS`, `DETAILS`
  These fields enable fine-grained SKU-to-vehicle mapping and Buyers Guide generation.

**Why merge both sources?**  
Combining AAIA and company-specific data provides both external compatibility and internal precision, enabling a scalable, autonomous, and reliable catalog system for real-world operations.

---

#### Sample Data

*ACES/PIES Example (1991 Nissan Pathfinder):*

| RegionID | Make   | Model      | Year | SubModel | VehicleType | FuelTypeName | DriveTypeName | TransmissionControlTypeName | BodyType      | BodyNumDoors | BaseVehicleID | AspirationName      | EngineBaseID | Liter | CC   | CID  | Cylinders | BlockType | SteeringSystemName | SteeringTypeName | VehicleID | BodyTypeID | BodyNumDoorsID | DriveTypeID | BrakeABSName   | CylinderHeadTypeName |
|----------|--------|------------|------|----------|-------------|--------------|---------------|-----------------------------|---------------|--------------|---------------|---------------------|--------------|-------|------|------|-----------|-----------|--------------------|------------------|-----------|------------|----------------|-------------|----------------|----------------------|
| 1        | Nissan | Pathfinder | 1991 | SE       | Truck       | GAS          | 4WD           | Automatic                   | Sport Utility | 4            | 12345         | Naturally Aspirated | 678          | 3.0   | 2960 | 181  | 6         | V         | Power              | Rack & Pinion    | 54321     | 5          | 4              | 4           | 4-Wheel ABS    | SOHC                |

*Company-Specific Example (Augmented for same vehicle):*

| MAKE   | MODEL      | BodyType      | Year | SUBMODEL | VehicleType | BodyNumDoors | MfrBodyCode | YrMax | COMMENTS | DETAILS | AAIAPARTTERMINOLOGY     | AAIAPOSITION | QUANTITY | TSPARTID | TSPARTIDLR | MEXICO | Liter | Cylinders | AspirationName      | FuelTypeName | DriveTypeName | Submodel_RockAuto | CanK | Opposite_Side_PARTID |
|--------|------------|---------------|------|----------|-------------|--------------|-------------|-------|----------|---------|------------------------|--------------|----------|----------|------------|--------|-------|-----------|---------------------|--------------|---------------|-------------------|------|----------------------|
| Nissan | Pathfinder | Sport Utility | 1991 | SE       | Truck       | 4            | NULL        | 1991  | NULL     | NULL    | Liftgate Lift Support  | NULL         | 2        | 611321   | 611321     | YES    | 3.0   | 6         | Naturally Aspirated | GAS          | 4WD           | SE                | YES  | NULL                 |
| Nissan | Pathfinder | Sport Utility | 1991 | SE       | Truck       | 4            | NULL        | 1991  | NULL     | NULL    | Back Glass Lift Support| Left         | 1        | 612921   | 612921     | YES    | 3.0   | 6         | Naturally Aspirated | GAS          | 4WD           | SE                | YES  | 612917               |
| Nissan | Pathfinder | Sport Utility | 1991 | SE       | Truck       | 4            | NULL        | 1991  | NULL     | NULL    | Back Glass Lift Support| Right        | 1        | 612917   | 612917     | YES    | 3.0   | 6         | Naturally Aspirated | GAS          | 4WD           | SE                | YES  | 612921               |

*All sample data is anonymized for demonstration.*

---

### Master Cross Reference Data

To enable accurate quoting and rapid lookups, the catalog also includes a **comprehensive cross-reference (“Master Cross”)** table mapping each internal part number (TSPARTID) to all related OEM and aftermarket competitor numbers. This used to be maintained manually and was prone to errors and inefficiency.

**Automating and normalizing this data with SQL provides:**
- Accurate customer quoting
- Faster catalog lookup and integration
- Scalability as more crosses and brands are added
- Reliable, unified exports for clients and partners

*Condensed Master Cross Sample:*

| Make   | OEM #        | OEM Cond #   | TSPARTID | Monroe # | Stabilus # | AC Delco # | Bugiad # | Meyle # | FCS # | Notes |
|--------|--------------|--------------|----------|----------|------------|------------|----------|---------|-------|-------|
| TOYOTA | 53450-A9030  | 53450A9030   | 613593   | 901393   | 461510     | 4326       | LS10116  | 013610  | 84326 |       |
| TOYOTA | 53450-69045  | 5345069045   | 613593   | 901393   | 461510     | 4326       | LS10116  | 013610  | 84326 |       |

---

**In summary:**  
This unified, structured dataset underpins the catalog’s accuracy, automation, and flexibility—delivering precise vehicle-part mapping, robust Buyers Guide assembly, and fast, reliable integration with customer and partner systems.

--- 

## Buyers Guide Construction & Cross Integration

To build a complete and distributable aftermarket catalog, I designed a three-stage process:

### Step 1: Build the Buyers Guide from Application Fitment Data

####  Buyers Guide View: `vw_TUF_BuyersGuide_All_woCross`

This SQL script defines a view that assembles a **comprehensive Buyers Guide** table for your catalog. Each row summarizes the full application, terminology, and essential notes for a unique part number (`TSPARTID`), drawing from your ACES-style raw fitment data.


 **What This View Does**

- **Gathers all part numbers** from the catalog
- **Aggregates all fitment applications** (make, model, year, etc.)
- **Summarizes body types and configurations**
- **Combines relevant notes, comments, and codes**
- **Lists AAIA part terminology, position, and quantity**

The result:  
A single, well-structured table providing every key Buyers Guide detail needed for internal analysis, catalog exports, or sharing with partners—**before joining to any cross-reference data**.

**SCRIPT "vw_TUF_BuyersGuide_All_woCross"**

```sql
CREATE VIEW vw_TUF_BuyersGuide_All_woCross AS
WITH UniqueTSPARTID AS (
    SELECT DISTINCT
        TSPARTID
    FROM TUF_CATALOG_AAIA
),

ApplicationInfo AS (
    SELECT
        TSPARTID,
        CASE 
            WHEN COUNT(CASE WHEN MAKE = 'UNIVERSAL' THEN 1 END) > 0 THEN 'Universal'
            ELSE STRING_AGG(MAKE + ': ' + ModelInfo, '  / ')
        END AS Application,
        MIN(MinYear) AS MinYear,
        MAX(MaxYear) AS MaxYear
    FROM (
        SELECT
            TSPARTID,
            MAKE,
            STRING_AGG(CONCAT(MODEL, ' (', MinYear, '–', MaxYear, ')'), '; ') AS ModelInfo,
            MIN(MinYear) AS MinYear,
            MAX(MaxYear) AS MaxYear
        FROM (
            SELECT
                TSPARTID,
                MAKE,
                MODEL,
                MIN([Year]) AS MinYear,
                MAX([Year]) AS MaxYear
            FROM TUF_CATALOG_AAIA
            GROUP BY TSPARTID, MAKE, MODEL
        ) AS ModelYearRanges
        GROUP BY TSPARTID, MAKE
    ) AS ModelsGroupedWithYearRanges
    GROUP BY TSPARTID
),

AggregatedBodyType AS (
    SELECT
        BodyInfo.TSPARTID,
        STRING_AGG(
            CASE 
                WHEN BodyRangeSummary.HasMultipleRanges = 0 THEN BodyInfo.BodyInfo
                ELSE CONCAT(BodyInfo.BodyInfo, ' (', BodyInfo.MinYear, '–', BodyInfo.MaxYear, ')')
            END,
            ', '
        ) AS BodyType
    FROM (
        SELECT
            TSPARTID,
            BodyNumDoors + ' Door ' + BodyType AS BodyInfo,
            MIN([Year]) AS MinYear,
            MAX([Year]) AS MaxYear
        FROM TUF_CATALOG_AAIA
        WHERE BodyNumDoors IS NOT NULL AND VehicleType IS NOT NULL
        GROUP BY TSPARTID, BodyNumDoors, BodyType
    ) AS BodyInfo
    JOIN (
        SELECT
            TSPARTID,
            CASE 
                WHEN COUNT(DISTINCT CAST(MinYear AS VARCHAR) + '-' + CAST(MaxYear AS VARCHAR)) > 1 THEN 1
                ELSE 0
            END AS HasMultipleRanges
        FROM (
            SELECT
                TSPARTID,
                BodyNumDoors,
                BodyType,
                MIN([Year]) AS MinYear,
                MAX([Year]) AS MaxYear
            FROM TUF_CATALOG_AAIA
            WHERE BodyNumDoors IS NOT NULL AND VehicleType IS NOT NULL
            GROUP BY TSPARTID, BodyNumDoors, BodyType
        ) AS Ranges
        GROUP BY TSPARTID
    ) AS BodyRangeSummary
        ON BodyInfo.TSPARTID = BodyRangeSummary.TSPARTID
    GROUP BY BodyInfo.TSPARTID, BodyRangeSummary.HasMultipleRanges
),

AggregatedNotes AS (
    SELECT 
        MBC.TSPARTID,
        MBC.MfrBodyCode,
        C.Cmnts AS Comments,
        D.Dtls AS Details,
        TRIM(' || ' FROM
            CASE WHEN MBC.MfrBodyCode IS NOT NULL AND MBC.MfrBodyCode <> '' THEN MBC.MfrBodyCode + ' || ' ELSE '' END +
            CASE WHEN C.Cmnts IS NOT NULL AND C.Cmnts <> '' THEN C.Cmnts + ' || ' ELSE '' END +
            CASE WHEN D.Dtls IS NOT NULL AND D.Dtls <> '' THEN D.Dtls ELSE '' END
        ) AS Notes
    FROM (
        SELECT 
            TSPARTID,
            STRING_AGG(MfrBodyCode, '; ') AS MfrBodyCode
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                MfrBodyCode
            FROM TUF_CATALOG_AAIA
        ) AS x
        GROUP BY TSPARTID
    ) AS MBC
    LEFT JOIN (
        SELECT 
            TSPARTID,
            STRING_AGG(COMMENTS, '; ') AS Cmnts
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                COMMENTS
            FROM TUF_CATALOG_AAIA
            WHERE COMMENTS IS NOT NULL
        ) AS y
        GROUP BY TSPARTID
    ) AS C ON MBC.TSPARTID = C.TSPARTID
    LEFT JOIN (
        SELECT 
            TSPARTID,
            STRING_AGG(DETAILS, '; ') AS Dtls
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                DETAILS
            FROM TUF_CATALOG_AAIA
            WHERE DETAILS IS NOT NULL
        ) AS z
        GROUP BY TSPARTID
    ) AS D ON MBC.TSPARTID = D.TSPARTID
),

AggregatedTerminology AS (
    SELECT
        TSPARTID,
        (
            SELECT STRING_AGG(AAIAPARTTERMINOLOGY, '; ')
            FROM (
                SELECT DISTINCT TSPARTID, AAIAPARTTERMINOLOGY
                FROM TUF_CATALOG_AAIA
            ) AS DistinctTerminology
            WHERE DistinctTerminology.TSPARTID = base.TSPARTID
        ) AS PartTerminology,

        (
            SELECT STRING_AGG(AAIAPOSITION, '; ')
            FROM (
                SELECT DISTINCT TSPARTID, AAIAPOSITION
                FROM TUF_CATALOG_AAIA
            ) AS DistinctPosition
            WHERE DistinctPosition.TSPARTID = base.TSPARTID
        ) AS Position,

        (
            SELECT STRING_AGG(QUANTITY, '; ')
            FROM (
                SELECT DISTINCT TSPARTID, QUANTITY
                FROM TUF_CATALOG_AAIA
            ) AS DistinctQuantity
            WHERE DistinctQuantity.TSPARTID = base.TSPARTID
        ) AS QuantityNeeded
    FROM (
        SELECT DISTINCT TSPARTID
        FROM TUF_CATALOG_AAIA
    ) AS base
)

SELECT 
    UniqueTSPARTID.TSPARTID AS TSPARTID,
    ApplicationInfo.Application AS Application,
    ApplicationInfo.MinYear AS MinYear,
    ApplicationInfo.MaxYear AS MaxYear,
    AggregatedBodyType.BodyType AS BodyType,
    AggregatedTerminology.PartTerminology AS PartTerminology,
    AggregatedTerminology.Position AS Position,
    AggregatedNotes.Notes AS Notes,
    AggregatedTerminology.QuantityNeeded AS QuantityNeeded
FROM UniqueTSPARTID
LEFT JOIN ApplicationInfo 
    ON UniqueTSPARTID.TSPARTID = ApplicationInfo.TSPARTID
LEFT JOIN AggregatedBodyType 
    ON UniqueTSPARTID.TSPARTID = AggregatedBodyType.TSPARTID
LEFT JOIN AggregatedNotes 
    ON UniqueTSPARTID.TSPARTID = AggregatedNotes.TSPARTID
LEFT JOIN AggregatedTerminology
    ON UniqueTSPARTID.TSPARTID = AggregatedTerminology.TSPARTID
```


**Step-by-Step Explanation**

##### 1. `UniqueTSPARTID`
- Pulls every unique part number in the catalog.

##### 2. `ApplicationInfo`
- For each part, aggregates all fitment applications into a readable string like:  
  `Nissan: Pathfinder (1991–1995); Altima (1996–1998) / Toyota: Camry (2000–2002)`
- Handles “Universal” fitments as a special case.

##### 3. `AggregatedBodyType`
- Summarizes all body types (e.g., “4 Door SUV (1991–1995)”).
- Adds year ranges for body types that change over time.

##### 4. `AggregatedNotes`
- Combines manufacturer body codes, comments, and details.
- Only non-empty values are concatenated, separated by `||`.

##### 5. `AggregatedTerminology`
- Lists AAIA part terminology (e.g., “Lift Support”), position (“Left; Right”), and quantity needed.

##### 6. **Final SELECT**

- Joins all the above CTEs using `TSPARTID` as the key.
- Each row = one part, with full application and descriptive metadata.
- This view is ready for downstream joins (e.g., to your Master Cross table) or as a Buyers Guide export.

**Sample Output Columns**

| Column           | Description                                             |
|------------------|---------------------------------------------------------|
| TSPARTID         | Internal catalog part number                            |
| Application      | Complete fitment string (Make, Model, Year)             |
| MinYear/MaxYear  | Earliest and latest fitment years                       |
| BodyType         | Detailed body/door summary with years if needed         |
| PartTerminology  | AAIA standard terminology (e.g., Lift Support)          |
| Position         | Position information (e.g., Left, Right)                |
| Notes            | Combined notes, codes, comments                         |
| QuantityNeeded   | Quantity required per vehicle                           |


#### **Resulting Table**

| TSPARTID | Application                                                                                                                                                                  | MinYear | MaxYear | BodyType                                                                                  | PartTerminology        | Position | Notes             | QuantityNeeded |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|---------|-------------------------------------------------------------------------------------------|------------------------|----------|-------------------|---------------|
| 611049   | Ford: Taurus (1996–1999)  / Mercury: Sable (1996–2005)                                                                                | 1996    | 2005    | 4 Door Wagon                                                                              | Liftgate Lift Support  |          | E54D; ME54D       | 2             |
| 611050   | Chevrolet: Silverado 2500 HD (2020–2024); Silverado 3500 HD (2020–2024)                                                               | 2020    | 2024    | 2 Door Cab & Chassis, 2 Door Standard Cab Pickup, 4 Door Cab & Chassis, 4 Door Crew Cab Pickup, 4 Door Extended Cab Pickup | Hood Lift Support      |          | Gas Engine        | 2             |
| 611053   | Cadillac: Eldorado (1992–2002); Seville (1992–1996)                                                                                   | 1992    | 2002    | 2 Door Coupe (1992–2002), 2 Door Sedan (1995–1997), 4 Door Sedan (1992–1996)              | Hood Lift Support      |          |                   | 2             |
| 611054   | Audi: Q2 (2017–2022); Q2 Quattro (2018–2022)                                                                                          | 2017    | 2022    | 4 Door Sport Utility                                                                      | Liftgate Lift Support  |          | GAB \|\| w/ Manual| 2             |
| 611055   | Mercedes-Benz: CLS-Class (2008–2011)                                                                                                  | 2008    | 2011    | 4 Door Coupe                                                                              | Trunk Lid Lift Support |          | CL203             | 2             |
| 611056   | Volkswagen: Arteon (2017–2022)                                                                                                        | 2017    | 2022    | 4 Door Hatchback                                                                          | Liftgate Lift Support  |          | w/o Power         | 2             |
| 611057   | Chrysler: Caravan (1984–1990); Town & Country (1984–1990)  / Dodge: Caravan (1984–1990); Grand Caravan (1984–1990)  / Plymouth: Grand Voyager (1987–1990); Voyager (1984–1990) | 1984    | 1990    | 3 Door Mini Passenger Van, 4 Door Mini Passenger Van                                      | Liftgate Lift Support  |          |                   | 2             |


---

### Step 2.1 Cross Reference Integration: Normalizing the Master Cross

In legacy catalog management, cross-reference tables are often assembled and updated manually. Each brand or cross type is represented as a separate column, leading to a fragmented and inefficient structure. This approach—while common in small or legacy operations—quickly becomes unmanageable as the catalog scales, especially when:

- New competitor crosses, superseding OE numbers, or regional variations are introduced
- Individual parts map to multiple crosses, resulting in row duplication and data redundancy
- Manual edits propagate inconsistencies over time

**Initial State:**  
Each brand had its own column in the cross-reference table. If a part corresponded to multiple competitor numbers or OE supersessions, duplicate rows were created to capture all possible crosses. The result was a wide, repetitive, and error-prone dataset that hampered both automation and reliable lookups.


The Transformation Challenge

To modernize and streamline the catalog, my first priority was to **normalize** the cross-reference data—**flattening** the table and eliminating duplicates. My solution was to create a view called `vw_TUF_Unpivoted_IntMaster_wMake`, which programmatically unpivots the legacy wide-format table into a clean, analytical structure with only three key columns:

- `TSPARTID` — Our internal part number  
- `Crossname` — The competitor or OE cross-reference number  
- `Make` — The brand or source of the cross (e.g., Monroe, Stabilus, AC Delco, OE, etc.)

This restructuring is a **one-time process** that converts years of inconsistent manual data entry into a robust and query-friendly format, providing a foundation for further automation and ongoing catalog maintenance.


**Benefits of the Normalized Structure**

- **Efficiency:** Drastically reduces manual management and maintenance workload  
- **Consistency:** Eliminates duplicates, ambiguity, and human error  
- **Scalability:** Supports effortless integration of new crosses or brands  
- **Automation Ready:** Enables seamless joins with Buyers Guide and downstream analytics

The resulting unpivoted dataset, maintained via the `vw_TUF_Unpivoted_IntMaster_wMake` view, is now the authoritative source for all future cross-reference updates, exports, and integrations.

**SCRIPT "vw_TUF_Unpivoted_IntMaster_wMake"**

```sql
CREATE VIEW [dbo].[vw_TUF_Unpivoted_IntMaster_wMake]
AS
SELECT DISTINCT 
    Unpivoted.TSPARTID, 
    Unpivoted.CrossName, 
    Unpivoted.CrossingNumber, 
    TUF_IntMaster.Make
FROM (
    SELECT DISTINCT 
        TSPARTID, 
        CrossName, 
        CrossingNumber
    FROM TUF_IntMaster
    UNPIVOT (
        CrossingNumber FOR CrossName IN (
            [OEM], [SA], [Sachs], [Mightylift], [FCS], [Stabilus], [Martas], [URO], [TRW], 
            [Monroe], [Napa], [QH], [Helmer], [Piston], [Kilen], [Optimal], [Meyle], [MagMar], 
            [Ferron], [Febi], [Lip], [AC_Delco], [Decar], [Liftgate], [Bugiad], [Triscan], 
            [Les], [FA], [Delphi], [Hans_Pries], [Vierol], [Mapco], [Destek], [Cofap], 
            [Air_Kraft], [Arnott], [MonroeEUR], [AMS], [Johns], [Klaxcar], [SYD], [DMA], 
            [Auger], [Sampa], [Sem_Plastik], [Stellox], [Orex], [DT_Spare_Parts], [Veka]
        )
    ) AS A
    WHERE CrossingNumber IS NOT NULL
) AS Unpivoted
LEFT JOIN TUF_IntMaster 
    ON Unpivoted.CrossingNumber = TUF_IntMaster.OEM;
```

This SQL view performs the essential **unpivoting and normalization** of the legacy Master Cross table (`TUF_IntMaster`). The goal is to convert the old, wide-format table (where each cross brand is a column) into a **clean, flat, and analytical table**—making downstream processing and joining far more efficient.


#### **Step-by-Step Logic**

##### 1. **UNPIVOT the Table**

- The `UNPIVOT` operation transforms multiple cross-reference columns (e.g., `[OEM]`, `[Monroe]`, `[Stabilus]`, etc.) into two columns:
  - `CrossName`: The brand or source of the cross (column name)
  - `CrossingNumber`: The actual competitor or OE number for the cross

**Result:**  
Instead of one wide row with 40+ cross columns, you get **one row per part per cross**, making the dataset "long" and normalized.

##### 2. **Filter Out Null Crosses**

- The `WHERE CrossingNumber IS NOT NULL` clause ensures that only valid, populated cross numbers are included—removing empty, unused, or irrelevant entries.

##### 3. **DISTINCT Selection**

- Both in the subquery and the outer SELECT, `DISTINCT` is used to avoid duplicate rows that could arise from legacy data or multiple identical crosses.

##### 4. **Add the Make**

- The outer query performs a `LEFT JOIN` to the original `TUF_IntMaster` table on `CrossingNumber = OEM`.
- This step pulls in the `Make` (car manufacturer/brand) associated with the OE number for each cross-reference. (If the cross is not an OEM number, `Make` may be NULL.)

##### 5. **Output Columns**

- The resulting view returns:
  - `TSPARTID` (your internal part number)
  - `CrossName` (cross brand or source, e.g., Monroe, OEM, Sachs)
  - `CrossingNumber` (the actual competitor/OE part number)
  - `Make` (brand, if determinable via OEM link)


#### **Resulting Table**

| TSPARTID | CrossName | CrossingNumber | Make   |
|----------|-----------|---------------|--------|
| 613593   | OEM       | 53450-A9030   | TOYOTA |
| 613593   | Monroe    | 901393        | NULL   |
| 613593   | Stabilus  | 461510        | NULL   |
| ...      | ...       | ...           | ...    |


#### **Summary**

This view transforms your legacy, manual cross-reference table into a **clean, query-ready structure**—removing redundancy, supporting automation, and allowing direct joins to Buyers Guide application data for a fully enriched catalog.

### Step 2.2 Cross Reference Condensing & Re-Pivoting

After normalizing the cross-reference data into a long, unpivoted format, the next challenge was to create a clean, consolidated, and export-friendly matrix of competitor and OEM numbers for every part. The legacy data contained many variations and duplicates due to inconsistent manual entry—sometimes the same cross number would appear with different punctuation, spacing, or casing. To ensure a professional and reliable catalog, I built a process that condenses, deduplicates, and pivots these references into a wide-format table with perfectly normalized cross numbers for each brand. This fully-automated transformation replaces manual clean-up and guarantees consistency across the catalog.

**SCRIPT "vw_TUF_Pivoted_IntMaster_Cond_Aggregated"**

```sql
ALTER VIEW [dbo].[vw_TUF_Pivoted_IntMaster_Cond_Aggregated] AS
WITH UnpivotedCondensed AS (
    SELECT DISTINCT
        TSPARTID,
        CrossName,
        UPPER(REPLACE(REPLACE(REPLACE(CrossingNumber, '-', ''), ' ', ''), '.', '')) AS CrossingNumberCondensed
    FROM vw_TUF_Unpivoted_IntMaster_wMake
),
UnpivotedCondensedAgg AS (
    SELECT
        TSPARTID,
        CrossName,
        STRING_AGG(CrossingNumberCondensed, '; ') AS CrossNumberCondensedAgg
    FROM UnpivotedCondensed
    GROUP BY TSPARTID, CrossName
)
SELECT *
FROM UnpivotedCondensedAgg
PIVOT (
    MAX(CrossNumberCondensedAgg)
    FOR CrossName IN (
        [OEM], [SA], [Sachs], [Mightylift], [FCS], [Stabilus], [Martas], [URO], [TRW],
        [Monroe], [Napa], [QH], [Helmer], [Piston], [Kilen], [Optimal], [Meyle], [MagMar],
        [Ferron], [Febi], [Lip], [AC_Delco], [Decar], [Liftgate], [Bugiad], [Triscan],
        [Les], [FA], [Delphi], [Hans_Pries], [Vierol], [Mapco], [Destek], [Cofap],
        [Air_Kraft], [Arnott], [MonroeEUR], [AMS], [Johns], [Klaxcar], [SYD], [DMA],
        [Auger], [Sampa], [Sem_Plastik], [Stellox], [Orex], [DT_Spare_Parts], [Veka]
    )
) AS PivotedResult;
```

This view takes the **normalized cross-reference data** (from `vw_TUF_Unpivoted_IntMaster_wMake`) and processes it to provide a **condensed, pivoted matrix** of all competitor and OEM numbers per part. The result is a highly usable, duplicate-free table that is easy to join or export for catalog use.

**What This View Does**

- **Condenses cross numbers:**  
  Removes dashes, spaces, and periods from cross numbers and converts them to uppercase for maximum consistency and deduplication (e.g., `"53-450.A9030"` → `"53450A9030"`).
- **Aggregates duplicates:**  
  Groups any repeated cross numbers into a single, semicolon-separated list for each brand per part.
- **Pivots back to wide format:**  
  The view outputs one row per part number (`TSPARTID`), with each cross-reference brand as its own column (e.g., `[OEM]`, `[Monroe]`, `[Sachs]`, etc.). This makes it convenient for export, analysis, or reporting.

---

#### **How the View Works — Step by Step**

##### 1. `UnpivotedCondensed`
- Pulls from the previously unpivoted, long-format cross-reference view (`vw_TUF_Unpivoted_IntMaster_wMake`).
- For each row, **condenses** the cross number:
  - Removes dashes, spaces, and periods.
  - Converts all characters to uppercase.
  - This normalizes variations in how cross numbers may be entered or formatted.

##### 2. `UnpivotedCondensedAgg`
- Groups by both `TSPARTID` and `CrossName` (brand).
- Aggregates all condensed cross numbers for that brand into a **semicolon-separated list** (using `STRING_AGG`).
- Ensures there are no duplicate cross numbers per part/brand.

##### 3. **PIVOT**
- Re-pivots the data, producing a **wide table**:
  - Each `TSPARTID` is a row.
  - Each cross brand (e.g., `[OEM]`, `[Monroe]`, `[Stabilus]`, etc.) is a column.
  - Cell values are the semicolon-separated, deduplicated cross numbers for that part and brand (or NULL if no cross).


#### **Sample Output**

| TSPARTID | OEM            | Monroe       | Sachs    | Stabilus  | ... |
|----------|----------------|-------------|----------|-----------|-----|
| 613593   | 53450A9030     | 901393      | 4326     | 461510    | ... |
| 612350   | 52088258;52088 | 900520      | 4242     | 469200    | ... |


#### **Benefits**

- **Data Consistency:** All cross numbers follow a single, normalized format.
- **Deduplication:** Repeated or variant entries are collapsed into one.
- **Query & Export Ready:** Data is in a familiar matrix (wide) layout, easy for lookup, reporting, or catalog publishing.
- **Automated:** This process is repeatable—no more manual Excel work!


**In summary:**  
This view delivers a clean, deduplicated, pivoted matrix of cross-references for every part, forming the foundation for the final, fully enriched Buyers Guide export.

### Step 3: Automated Buyers Guide Refresh (Stored Procedure)

Once all underlying views are in place, I created a stored procedure to fully automate the generation and maintenance of the Buyers Guide table. This stored procedure—`sp_TUF_Create_BuyersGuide`—dynamically rebuilds the Buyers Guide every time it is run.

Whenever parts are added, modified, or removed in the `TUF_CATALOG_AAIA` master table, I simply run this stored procedure. It automatically drops and recreates the `TUF_BuyersGuide` table, combining the latest application fitment data with the most up-to-date cross-reference information from the supporting views.

**How it works:**

- **Drop & Rebuild:**  
  The procedure deletes the existing Buyers Guide table (if present) and creates a fresh version, eliminating any risk of outdated or duplicate data.

- **Seamless Integration:**  
  Joins the comprehensive application data from `vw_TUF_BuyersGuide_All_woCross` with the normalized cross-reference matrix from `vw_TUF_Pivoted_IntMaster_Cond_Aggregated`.

- **Always Current:**  
  Every change to the core catalog is reflected instantly—one command refreshes the entire Buyers Guide for internal teams, exports, and customer-facing deliverables.

- **No Manual Intervention:**  
  Catalog maintenance becomes a one-step, automated process—saving time and ensuring accuracy at every update.

**SCRIPT sp_TUF_Create_BuyersGuide**

```sql
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_TUF_Create_BuyersGuide]
AS
BEGIN

    -- Check if table exists and drop it if necessary
    IF OBJECT_ID('dbo.TUF_BuyersGuide', 'U') IS NOT NULL
        DROP TABLE dbo.TUF_BuyersGuide;

    -- Create new TS_BuyersGuide table
    SELECT
        b.TSPARTID,
        b.Application,
        b.MinYear,
        b.BodyType,
        b.PartTerminology,
        b.Position,
        b.Notes,
        b.QuantityNeeded,
        p.OEM AS OEM_Cond,
        p.SA,
        p.Sachs,
        p.Mightylift,
        p.FCS,
        p.Stabilus
    INTO dbo.TUF_BuyersGuide
    FROM vw_TUF_BuyersGuide_All_woCross AS b
    LEFT JOIN vw_TUF_Pivoted_IntMaster_Cond_Aggregated AS p
        ON b.TSPARTID = p.TSPARTID;

END
```
This stored procedure drops and recreates the TUF_BuyersGuide table by joining up-to-date fitment data with cross-reference numbers. Running it ensures your Buyers Guide always reflects the latest catalog changes—fully automated and no manual updates required.

## Usage & Maintenance

- **Routine Updates:**  
  - When new parts are introduced or catalog updates are needed, add/update the raw data in `TUF_CATALOG_AAIA` and cross-reference tables.
  - Run the `sp_TUF_Create_BuyersGuide` stored procedure to instantly rebuild the Buyers Guide for internal or external use.

- **Customization:**  
  - To support additional cross brands, simply add new columns to the cross-reference logic and update the views accordingly.
  - For further field mapping or format changes, modify the relevant view scripts.
