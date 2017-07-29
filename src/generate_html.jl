
function generate_html(integrators, figures, prefix, suffix, fig_dir, output_dir, output_file;
                        title="", params=nothing, max_height="200px")
    header = """
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <title>GeometricExamples.jl $title</title>
            <meta charset="utf-8" />
            <meta name="authors" content="Michael Kraus" />
            <style>
                body {
                    background-color: #ffffff;
                    font-family: 'Lato', 'Helvetica Neue', Arial, sans-serif;
                    font-size: 16px;
                    color: #222;
                    text-rendering: optimizeLegibility;
                    text-align: center;
                }
                h1 {
                    font-size: 1.75em;
                }
                table {
        			border: 0px solid #ffffff;
        		}
                td {
                    border: 0px solid #ffffff;
        			text-align: center;
                    padding:2px
        		}
                th {
                    border: 0px solid #ffffff;
        			text-align: left;
        		}
                th:hover {
                    text-decoration: underline;
        		}
                img{
                    max-height: $max_height;
                    width: auto;
                    height: auto;
                    object-fit: contain;
                }
    		</style>
            <script>
                function sortTable(n) {
                  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                  table = document.getElementById("plot_table");
                  switching = true;
                  dir = "asc";
                  while (switching) {
                    switching = false;
                    rows = table.getElementsByTagName("TR");
                    for (i = 1; i < (rows.length - 1); i++) {
                      shouldSwitch = false;
                      x = rows[i].getElementsByTagName("TD")[n];
                      y = rows[i + 1].getElementsByTagName("TD")[n];
                      if (dir == "asc") {
                        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                          shouldSwitch= true;
                          break;
                        }
                      } else if (dir == "desc") {
                        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                          shouldSwitch= true;
                          break;
                        }
                      }
                    }
                    if (shouldSwitch) {
                      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                      switching = true;
                      switchcount ++;
                    } else {
                      if (switchcount == 0 && dir == "asc") {
                        dir = "desc";
                        switching = true;
                      }
                    }
                  }
                }
            </script>

        </head>

        <body>
            <div style="display: inline-block;">
    """

    footer = """
            </div>
        </body>
    </html>
    """

    # 1. Header
    # 2. Simulation information (runid, Δt, nt, ...)
    # 3. Figures with caption: integrator, tableau
    # 4. Libray settings (solver, atol, rtol, stol, ...)
    # 5. Footer


    # generate empty output string
    html = ""

    # add header
    html = html * header

    # add title
    if title != ""
        html = html * "<h1>" * title * "</h1>\n"
    end

    # write simulation parameters
    if params != nothing
        html = html * "<br/>\n"
        html = html * "<table>\n"
        html = html * "<thead>\n"
        html = html * "<tr>\n"
        html = html * "<td style='text-align: left; min-width: 250px;'><b>Simulation Parameters</b></td>\n"
        html = html * "<td style='text-align: left;'></td>\n"
        html = html * "</tr>\n"
        html = html * "</thead>\n"
        html = html * "<tbody>\n"

        for (key, value) in params
            html = html * "<tr>\n"
            html = html * "<td style='text-align: left;'>" * string(key) * "</td>\n"
            html = html * "<td style='text-align: left;'>" * string(value) * "</td>\n"
            html = html * "</tr>\n"
        end

        html = html * "</tbody>\n"
        html = html * "</table>\n"
        html = html * "<br/><br/>\n"
    end

    # start table
    html = html * "<table id='plot_table'>\n"

    # table header
    html = html * "<thead>\n"
    html = html * "<tr>\n"
    html = html * "<th onclick='sortTable(0)'><b>Integrator</b></th>\n"
    html = html * "<th onclick='sortTable(1)'><b>Tableau</b></th>\n"

    for fig in figures
        html = html * "<th></th>\n"
    end

    html = html * "</tr>\n"
    html = html * "</thead>\n"

    # plots for each integrator/tableau combination
    html = html * "<tbody>\n"
    for run in integrators
        int   = string(run[1])[(rsearchindex(string(run[1]), ".Integrator") + 11):end]
        tab   = string(run[2].name)
        file  = run[3]

        html = html * "<tr>\n"
        html = html * "<td style='text-align: left'>" * int * "</td>\n"
        html = html * "<td style='text-align: left'>" * tab * "</td>\n"

        for fig in figures
            fig_file = fig_dir * "/" * prefix * file * fig * suffix

            html = html * "<td>"
            if isfile(output_dir * "/" * fig_file)
                html = html * "<a href='"  * fig_file * "'>"
                html = html * "<img src='" * fig_file * "'>"
                html = html * "</a>"
            end
            html = html * "</td>\n"
        end

        html = html * "</tr>\n"
    end
    html = html * "</tbody>\n"

    # finish table
    html = html * "</table>\n"

    # write library settings
    settings = get_config_dictionary()

    html = html * "<br/>\n"
    html = html * "<table>\n"
    html = html * "<thead>\n"
    html = html * "<tr>\n"
    html = html * "<td style='text-align: left'; min-width: 300px;><b>Library Settings</b></td>\n"
    html = html * "<td style='text-align: left';></td>\n"
    html = html * "</tr>\n"
    html = html * "</thead>\n"
    html = html * "<tbody>\n"

    for key in sort(collect(keys(settings)))
        html = html * "<tr>\n"
        html = html * "<td style='text-align: left;'>" * string(key) * "</td>\n"
        html = html * "<td style='text-align: left;'>" * string(settings[key]) * "</td>\n"
        html = html * "</tr>\n"
    end

    html = html * "</tbody>\n"
    html = html * "</table>\n"
    html = html * "<br/><br/>\n"

    # add footer
    html = html * footer


    open(output_dir * "/" * output_file, "w") do f
        write(f, html)
    end

end
