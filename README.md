
# oewd_sample_project

<!-- badges: start -->
<!-- badges: end -->

This sample project is for demonstration purposes only.

## Pipeline

```mermaid
flowchart TD
    subgraph udp["Unified Data Platform"]
        SF[("Snowflake<br/>UDP_DATABASE.SNAPSHOTS")]
    end

    subgraph pipeline["targets pipeline (_targets.R)"]
        direction TB
        SQL["sql/sample_query.sql<br/>tar_udp() = tar_sql() + query_params"]
        CONN["connect_to_udp()<br/>R/udp_utils.R"]
        TGT["target: data_from_snowflake<br/>cached in _targets/ as qs"]
        QMD["reports/sample_report.qmd<br/>tar_quarto()"]
    end

    subgraph quarto["Quarto render"]
        direction TB
        EXT["oewd-report-html format<br/>_extensions/SFOEWD/oewd-report"]
        HTML["self-contained .html<br/>embed-resources: true"]
        POST["post-render hook<br/>upload_report_to_sharepoint.R"]
    end

    subgraph sp["Microsoft 365"]
        DRIVE[("SharePoint site<br/>'Documents' drive")]
    end

    CONN -->|"ODBC Snowflake driver<br/>snowflake_jwt key-pair auth"| SF
    SQL -->|"executed over connection"| CONN
    SF -.->|"result set"| TGT
    TGT -->|"tar_read(data_from_snowflake)"| QMD
    QMD --> EXT
    EXT -->|"gt tables + ggplot2 figures"| HTML
    HTML --> POST
    POST -->|"Microsoft365R<br/>sp_docs$upload_file()"| DRIVE
```

### How it works

1. **Query** — `tar_udp()` (a `tar_sql()` partial carrying `query_params`) runs `sql/sample_query.sql`. The connection comes from `connect_to_udp()`, which opens an ODBC session against Snowflake using JWT key-pair auth, with server, database, warehouse, user, and private key all read from environment variables.
2. **Cache** — the result set lands in the `targets` store as the `data_from_snowflake` target, serialized with `qs`. `targets` invalidates it when the SQL file or its params change, so Snowflake is only re-queried when the query actually changes.
3. **Render** — `tar_quarto()` renders `reports/sample_report.qmd`, which pulls the cached data back in with `tar_read()`. The `oewd-report-html` extension supplies OEWD branding, SF Design System icons, and SCSS theming; `embed-resources: true` inlines everything into a single portable HTML file.
4. **Publish** — the extension's `_quarto.yml` declares a `post-render` hook, so Quarto runs `upload_report_to_sharepoint.R` immediately after a successful render. That script reads the rendered file path from `QUARTO_PROJECT_OUTPUT_FILES` and pushes it to the SharePoint `Documents` drive via `Microsoft365R`.

