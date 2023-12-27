# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rocketsized.Repo.insert!(%Rocketsized.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Rocketsized.Repo
alias Rocketsized.Rocket.Vehicle
alias Rocketsized.Rocket.Stage
alias Rocketsized.Rocket.Motor
alias Rocketsized.Rocket.Family
alias Rocketsized.Rocket.Launch
alias Rocketsized.Creator.Country
alias Rocketsized.Creator.Manufacturer

# Repo.delete_all(Manufacturer)
# Repo.delete_all(Country)

# us =
#   Repo.insert!(%Country{
#     name: "United States",
#     code: "US",
#     flag: """
#       <svg xmlns="http://www.w3.org/2000/svg" id="flag-icons-us" viewBox="0 0 640 480">
#         <path fill="#bd3d44" d="M0 0h640v480H0"/>
#         <path stroke="#fff" stroke-width="37" d="M0 55.3h640M0 129h640M0 203h640M0 277h640M0 351h640M0 425h640"/>
#         <path fill="#192f5d" d="M0 0h364.8v258.5H0"/>
#         <marker id="us-a" markerHeight="30" markerWidth="30">
#           <path fill="#fff" d="m14 0 9 27L0 10h28L5 27z"/>
#         </marker>
#         <path fill="none" marker-mid="url(#us-a)" d="m0 0 16 11h61 61 61 61 60L47 37h61 61 60 61L16 63h61 61 61 61 60L47 89h61 61 60 61L16 115h61 61 61 61 60L47 141h61 61 60 61L16 166h61 61 61 61 60L47 192h61 61 60 61L16 218h61 61 61 61 60L0 0"/>
#       </svg>
#       <path xmlns="http://www.w3.org/2000/svg" fill="#bd3d44" d="M0 0h640v480H0"/>
#       <path xmlns="http://www.w3.org/2000/svg" stroke="#fff" stroke-width="37" d="M0 55.3h640M0 129h640M0 203h640M0 277h640M0 351h640M0 425h640"/>
#       <path xmlns="http://www.w3.org/2000/svg" fill="#192f5d" d="M0 0h364.8v258.5H0"/>
#       <marker xmlns="http://www.w3.org/2000/svg" id="us-a" markerHeight="30" markerWidth="30">
#           <path fill="#fff" d="m14 0 9 27L0 10h28L5 27z"/>
#         </marker>
#       <path xmlns="http://www.w3.org/2000/svg" fill="none" marker-mid="url(#us-a)" d="m0 0 16 11h61 61 61 61 60L47 37h61 61 60 61L16 63h61 61 61 61 60L47 89h61 61 60 61L16 115h61 61 61 61 60L47 141h61 61 60 61L16 166h61 61 61 61 60L47 192h61 61 60 61L16 218h61 61 61 61 60L0 0"/>
#       <svg xmlns="http://www.w3.org/2000/svg" id="flag-icons-us" viewBox="0 0 640 480">
#         <path fill="#bd3d44" d="M0 0h640v480H0"/>
#         <path stroke="#fff" stroke-width="37" d="M0 55.3h640M0 129h640M0 203h640M0 277h640M0 351h640M0 425h640"/>
#         <path fill="#192f5d" d="M0 0h364.8v258.5H0"/>
#         <marker id="us-a" markerHeight="30" markerWidth="30">
#           <path fill="#fff" d="m14 0 9 27L0 10h28L5 27z"/>
#         </marker>
#         <path fill="none" marker-mid="url(#us-a)" d="m0 0 16 11h61 61 61 61 60L47 37h61 61 60 61L16 63h61 61 61 61 60L47 89h61 61 60 61L16 115h61 61 61 61 60L47 141h61 61 60 61L16 166h61 61 61 61 60L47 192h61 61 60 61L16 218h61 61 61 61 60L0 0"/>
#       </svg>
#     """
#   })

# su =
#   Repo.insert!(%Country{
#     name: "USSR",
#     code: "SU",
#     flag: """
#       <svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" version="1.1" width="1200" height="600" id="svg10">
#       <metadata id="metadata16">
#         <rdf:RDF>
#           <cc:Work rdf:about="">
#             <dc:format>image/svg+xml</dc:format>
#             <dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/>
#             <dc:title/>
#           </cc:Work>
#         </rdf:RDF>
#       </metadata>
#       <defs id="defs14"/>
#       <path fill="#bc0000" fill-opacity="1" d="M0 0h1200v600H0z" id="path2" style="fill:#cc0000;fill-opacity:1"/>
#       <path id="path11728" d="m 200.0005,37.5 -8.41933,25.911886 H 164.336 L 186.37777,79.426122 177.95844,105.338 200.0005,89.323465 222.04257,105.338 213.62324,79.426122 235.665,63.411886 h -27.24516 z m 0,13.499987 5.38828,16.583473 h 17.43718 l -14.107,10.249496 5.38827,16.583472 L 200.0005,84.167224 185.89378,94.416428 191.28205,77.832956 177.17504,67.58346 h 17.43718 z" style="fill:#ffd700;fill-opacity:1;stroke:none;stroke-width:0.14999977px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"/>
#       <g style="fill:#ffd700;fill-opacity:1" id="g2900" transform="matrix(0.98931879,0,0,0.98673811,3.8297658,3.7659398)">
#         <path id="rect4165-6" d="m 137.43744,171.69421 18.86296,18.9937 17.78834,-17.66589 c 27.05847,29.021 55.43807,56.99501 82.28704,86.12782 4.03444,4.06233 10.59815,4.085 14.66056,0.0506 4.06232,-4.03445 4.08499,-10.59815 0.0506,-14.66056 -28.81871,-27.1901 -57.72545,-54.60143 -86.55328,-81.89095 l 23.96499,-23.80003 -33.34026,-4.61605 z" style="fill:#ffd700;fill-opacity:1;stroke:none;stroke-width:0.48919073;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1"/>
#         <path id="path4179-3" d="m 198.2887,110.1955 c 15.51743,8.7394 27.29872,21.28122 34.2484,34.3924 7.04394,13.28902 10.13959,27.16218 10.20325,38.25433 0.13054,22.74374 -18.43771,41.18184 -41.18183,41.18184 -12.13597,0 -23.04607,-5.24868 -30.58302,-13.60085 l -4.16863,3.51033 c -0.70999,-0.27231 -1.46387,-0.41221 -2.22429,-0.41276 -1.82948,1.9e-4 -3.56621,0.80531 -4.74859,2.20136 -2.97368,0.38896 -5.46251,2.44529 -6.40534,5.29224 -3.13486,6.28843 -8.63524,11.21997 -15.29104,13.4776 -0.0637,0.0216 -0.11992,0.05 -0.1758,0.0783 -3.07749,1.12758 -6.16259,3.1643 -8.78919,5.80245 -5.19155,5.23656 -7.72858,11.93658 -6.30024,16.63822 -0.14098,0.40857 -0.21361,0.83759 -0.21498,1.26979 1.5e-4,2.17082 1.75991,3.93058 3.93073,3.93073 0.54341,-0.002 1.08053,-0.11639 1.57745,-0.33632 4.69369,1.05881 11.06885,-1.54582 16.05444,-6.55917 2.82624,-2.85072 4.94356,-6.22349 5.98303,-9.53062 2.31696,-6.62278 7.29699,-12.01856 13.62281,-15.05312 0.15105,-0.0725 0.27303,-0.14714 0.38218,-0.22358 2.12082,-1.01408 3.67251,-2.92895 4.225,-5.2139 9.70222,11.44481 24.25255,18.75299 40.51876,19.13577 29.83352,0.70205 52.13299,-21.25802 53.16414,-52.83642 0.51894,-15.89259 -5.62993,-36.3847 -19.6412,-53.19089 -10.70835,-12.84441 -26.40987,-23.50795 -44.18699,-28.20777 z" style="fill:#ffd700;fill-opacity:1;stroke:none;stroke-width:0.50003481;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1"/>
#       </g>
#     </svg>
#     """
#   })

# cn =
#   Repo.insert!(%Country{
#     name: "China",
#     code: "CN",
#     flag: """
#       <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="900" height="600"><path fill="#EE1C25" d="M0 0h900v600H0"/><g transform="translate(150,150) scale(3)"><path id="s" d="M0,-30 17.63355,24.27051 -28.53171,-9.27051H28.53171L-17.63355,24.27051" fill="#FF0"/></g><use xlink:href="#s" transform="translate(300,60) rotate(23.036243)"/><use xlink:href="#s" transform="translate(360,120) rotate(45.869898)"/><use xlink:href="#s" transform="translate(360,210) rotate(69.945396)"/><use xlink:href="#s" transform="translate(300,270) rotate(20.659808)"/></svg>
#     """
#   })

# Repo.insert!(%Manufacturer{name: "NASA", country: us})
# Repo.insert!(%Manufacturer{name: "Energia", country: su})
# Repo.insert!(%Manufacturer{name: "CALT", country: cn})
