
module GeometricExamples

    using GeometricIntegrators

    export generate_html, package_version

    include("generate_html.jl")
    include("package_version.jl")

    export get_tableau_list_erk, get_tableau_list_firk, get_tableau_list_vprk,
           get_tableau_list_vprk_projection, get_tableau_list_vprk_radau,
           get_tableau_list_splitting

    include("tableau_lists.jl")

end
