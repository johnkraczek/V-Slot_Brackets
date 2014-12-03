PATH = %PATH%;C:\Program Files\OpenSCAD\
openscad.com -o Glass_Tab_w_Bolt.stl -D "gls_tab_only = true; gls_tab_retract = true" XboxBracket.scad
openscad.com -o Glass_Tab.stl -D "gls_tab_only = true; gls_tab_retract = false" XboxBracket.scad
openscad.com -o XboxBracket_w_bolt.stl -D "gls_tab_only = false; gls_tab_retract = true" XboxBracket.scad
openscad.com -o XboxBracket.stl -D "gls_tab_only = false; gls_tab_retract = false" XboxBracket.scad
