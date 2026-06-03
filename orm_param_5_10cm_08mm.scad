/* ==========================================================================
   PRINT-IN-PLACE FLEXI SNAKE
    Author: Noty https://github.com/Noty-design/Parametric-designs

    This is a highly customizable parametric snake toy designed for print-in-place
    flexibility. 
   
   ========================================================================== */

/* [Render Quality / Performance] */
// Higher values make the outside shell smoother but increase OpenSCAD render time.
envelope_steps = 110;
// Cylinders used in the zig-zag body..
body_cylinder_fn = 24;
// Spheres used for eyes and eye sockets.
eye_sphere_fn = 32;
// Smoothness of the cross-section dome. 48-64 is usually plenty.
profile_curve_fn = 64;
// Scale bumps are intentionally low-poly so dense scale coats do not become too heavy.
scale_sphere_fn = 12;

/* [Jaw parameters] */
// Gap clearance around the moving jaw (0.4mm guarantees free movement without welding)
jaw_clearance = 0.4;
// How far the mouth cuts into the head -> determines the length of the jaw bone
jaw_slit_depth = 15;
// Adjustable taper in the lower jaw near the hinge. Longer = softer bend,
// thinner = more flexible but weaker.
lower_jaw_taper_enabled = true;
// Length of the tapered section where the jaw thins into the hinge.
lower_jaw_taper_length = 8; 
// Minimum thickness at the hinge point. Keep above 0.8mm for durability, or set to 0 for maximum flexibility. Adjust taper length accordingly.
lower_jaw_taper_min_thickness = 0.9; 
// Extra side skin keeps the taper from cutting all the way through the jaw. Set to 0 for maximum flexibility, 
// or higher to keep more material in the tapered area for strength.
lower_jaw_taper_side_skin = 0;  
// Extra length beyond the hinge point where the taper gradually fades out. 
//This creates a smoother transition between the tapered hinge area and the thicker jaw tip, improving durability without sacrificing much flexibility.
lower_jaw_taper_fade_length = 2.5; 
// Downward thickening of the upper jaw underside to make the mouth gap follow
// the lower jaw taper more evenly.
upper_jaw_lip_enabled = true;
// Length of the upper lip extension that thickens the underside of the upper jaw. 
//This helps maintain a consistent mouth gap even as the lower jaw tapers, improving the appearance and function of the print-in-place hinge.
upper_jaw_lip_length = 7.5;
// Thickness of the upper lip extension. A thicker lip can help keep the mouth gap more even as the lower jaw tapers, but may reduce flexibility if too thick.
// Adjust this based on the taper settings to find the best balance of flexibility and a consistent mouth gap.
upper_jaw_lip_gap = 0.65;
// Extra side skin on the upper lip extension to prevent it from becoming too fragile as it extends forward. 
//Set to 0 for maximum flexibility, or higher to keep more material for strength.
upper_jaw_lip_overlap = 0.25;
// Extra length beyond the upper lip where the thickening gradually fades out. This creates a smoother transition and 
// prevents a sudden change in thickness that could be prone to breaking.
upper_jaw_lip_side_skin = 0;

/* [Hinge parameters] */
// Keep this at 2-3 layer heights for PETG/TPU; PLA may need a slightly longer flex section.
living_hinge_length = 2.8;
// Thickness of the living hinge web. Thinner = more flexible but weaker. 0.6-0.8mm is usually a good balance.
living_hinge_thickness = 0.6;
// Width of the living hinge web. Wider = stronger but less flexible. 8-12mm is a good range to experiment with.
living_hinge_width = 11;
// Extra length beyond the hinge where the web gradually fades out. 
//This creates a smoother transition and reduces stress concentration at the hinge ends, improving durability without sacrificing much flexibility.
living_hinge_anchor_length = 3.2;
// Thickness of the anchor sections on either side of the hinge. These keep the web securely attached to the jaw and head, 
// preventing it from peeling off during flexing.
living_hinge_anchor_thickness = 1.0;
// Overlap of the living hinge web onto the jaw and head. This extra material helps ensure the hinge stays securely attached and reduces 
// the risk of tearing, especially under heavy flexing.
living_hinge_overlap = 0.2;
// Extra side skin on the living hinge to prevent it from cutting all the way through the jaw and head.
living_hinge_side_skin = 0.8;

/* [BODY PARAMETERS] */
// Total length of the zig-zag flexible body
body_length = 100;
// Maximum outer width of the body (middle)
body_max_width = 26;
// Width at the neck hook-up (connects to head)
neck_width = 14.5;
// Width at the tail start (connects to tail)
tail_start_width = 8;
// Number of zig-zags (70 gives perfect density for this body length)
zig_zags = 45;
// Thickness of the extruded zig-zag wall (1.2mm gives amazing multi-directional flex)
wall_thickness = 0.8;
// Total base height of the snake body - Lowered to 11.5mm to allow beautiful vertical wave flexibility!
snake_height = 11.5;

/* [HEAD PARAMETERS] */
// Length from the neck joint to the snout tip. The head will be longer overall due to the jaw and hinge geometry, 
// but this controls the main head block size.
head_length = 20;
//  Width of the neck where the head connects to the body. This should match neck_width for a smooth transition, 
// but can be adjusted for a more tapered or flared neck.
snout_length = 14;
// Width of the main jaw area at its widest point. This controls how wide the head looks and how big the mouth can open.
head_jaw_width = 22;
// Height of the head at the snout base. This controls how tall the head looks and how much vertical space the jaw has to open.
snout_width = 16;
// Increased slightly so the top lip doesn't become too fragile above the slit
snout_height = 8;
// Position of the head flare that creates the jaw widening. This is a value from 0 to 1 where 0 is at the snout base and 1 is at the neck.
head_flare_pos = 0.65;

/* [Eye PARAMETERS] */
// Higher values move the eye socket deeper into the head.
eye_depth_into_head = 4.5;
// Higher values move the eye position up towards the top of the head.
eye_vertical_pos = 0.65; // 0 = at center height, 1 = at top of head, 0.5 = perfectly centered in vertical space of the head
// postion in steps of 0.01, higher values move the eye towards the tongue.
eye_horizontal_pos = 0.4; // 0 = at snout tip, 1 = at back of head, 0.5 = perfectly centered in horizontal space of the head

/* [TAIL PARAMETERS] */
// Total length of the tail section after the body. This is the flexible part of the tail; 
// the anchor section that connects to the body is controlled by head_tail_anchor_length.
tail_length = 30;
// Width of the tail at the point where it connects to the body. This should match tail_start_width for a smooth transition, 
// but can be adjusted for a more tapered or flared tail base.
tail_taper_curve = 1.4;


/* [BACK/TOP SHAPE PARAMETERS] */
// Back_flatness controls the shape of the back /topp of the snake. 0 = fully rounded dome, 1 = completely flat top. 
back_flatness = 0;
// Height of the straight vertical sides before the back curve starts (Lowered for vertical flex)
vertical_wall_height = 3.5;

/* [SCALE TEXTURE PARAMETERS] */
enable_scales = false;
// Base size of the scales. Higher values create larger scales, lower values create smaller scales. 
// Adjust this along with scale_overlap to find the best balance of coverage and printability.
scale_size = 4.8;
// How much each scale overlaps the previous one. Higher values create more overlap and fuller coverage, but can lead to heavier models and more print challenges.
scale_overlap = 0.55;

/* [STYLING & COLORS] */
body_color = "YellowGreen";
tongue_color = "Crimson";
eye_color = "DarkSlateGray";

// --- CALCULATED REFERENCE POINTS ---
// Effective values after applying constraints to prevent invalid geometry. 
// These are used throughout the model to ensure all math remains valid even with extreme Customizer inputs.
zig_zags_eff = max(1, floor(abs(zig_zags)));
// Effective wall thickness and snake height after enforcing minimum values for printability and functionality.
wall_thickness_eff = max(0.2, abs(wall_thickness));
// Snake height is used in many places as a base dimension, so it's important to enforce a reasonable minimum to prevent collapsing geometry.
snake_height_eff = max(1, abs(snake_height));
// Effective jaw taper dimensions after enforcing minimum thickness for durability and maximum length for flexibility.
body_segment_length = body_length / zig_zags_eff;
// The head and tail anchor lengths are based on the body segment length to ensure they are proportionate to the overall model size.
head_tail_anchor_length = body_segment_length * 1.5;

// X positions for the main head landmarks.
// The neck/body join is at X=0. The head and snout extend into negative X.
snout_base_x = -head_length;
// The snout tip is further out, but the exact position depends on the jaw slit depth and hinge geometry to ensure the mouth opens properly without breaking.
snout_tip_x = -head_length - snout_length;
// The head flare position is calculated based on the head_length and the head_flare_pos parameter, which determines where along the head length the flare occurs.
flare_x = -head_length * (1 - head_flare_pos);

// Hinge system tracking.
// The hinge is designed to be a flexible web that connects the lower jaw to the head, allowing it to bend without a traditional pin joint.
mouth_z_eval = 2.8; 
// The hinge is positioned so the center of the living hinge web is located at the mouth gap when the jaw is closed. 
// This allows for a natural bending motion when the jaw opens.
hx = snout_tip_x + jaw_slit_depth;
living_hinge_length_eff = max(0.1, abs(living_hinge_length));
living_hinge_thickness_eff = max(0.2, abs(living_hinge_thickness));
living_hinge_width_eff = max(0.1, abs(living_hinge_width));
living_hinge_anchor_length_eff = max(0.1, abs(living_hinge_anchor_length));
living_hinge_anchor_thickness_eff = max(0.2, abs(living_hinge_anchor_thickness));
living_hinge_overlap_eff = max(0, living_hinge_overlap);
living_hinge_side_skin_eff = max(0, living_hinge_side_skin);
living_hinge_flex_cx = hx - living_hinge_length_eff/2;
living_hinge_jaw_anchor_cx = hx - living_hinge_length_eff - living_hinge_anchor_length_eff/2;
living_hinge_head_anchor_cx = hx + living_hinge_anchor_length_eff/2;
living_hinge_relief_height = mouth_z_eval - living_hinge_thickness_eff;

// --- FUNCTIONS FOR SMOOTH PROFILES ---
// Helper math functions for smooth head and body transitions.
// OpenSCAD trig functions use degrees, so the interpolation maps t=0..1 to
// 0..180 degrees. That gives a gentle ease-in/ease-out instead of a linear ramp.
// Cosine interpolation between a and b based on t from 0 to 1. Clamped to prevent invalid math.
function cosine_interp(a, b, t) = a + (b - a) * (0.5 - 0.5 * cos(max(0, min(1, t)) * 180));
// Keep a value inside a known interval. Used heavily before sqrt()/division so
// Customizer values cannot create invalid math.
function clamp(val, min_val, max_val) = min(max(val, min_val), max_val);

// Compute head width at a given x coordinate, blending snout, jaw, and neck.
// The expression has three regions:
// 1. Elliptical snout from tip to snout base.
// 2. Smooth widening from snout base into the main jaw width.
// 3. Smooth narrowing from the jaw flare back into the neck/body width.
function get_head_width(x) =
    (x <= snout_base_x) ? 
    // Rounded snout front: an ellipse that goes from snout_width at the base to 0 at the tip. The sqrt creates the rounded profile.
        snout_width * sqrt(max(0.001, 1 - pow((x - snout_base_x)/snout_length, 2))) :
    (x <= flare_x) ? 
    // Blend from snout width to head jaw width across the jaw area for a smooth transition.
        cosine_interp(snout_width, head_jaw_width, (x - snout_base_x) / (flare_x - snout_base_x)) :
    // Blend from head jaw width back to neck width across the flare area for a smooth transition into the body.
        cosine_interp(head_jaw_width, neck_width, (x - flare_x) / (0 - flare_x));

// Compute the outer width of the zig-zag body shape as a normalized curve.
// t is 0 at the neck and 1 at the tail start. The sine curve makes the body
// widest in the middle and narrower at both ends.
function get_zigzag_outer(t) = 
    let ( 
        // Use different endpoint widths before/after the center so the curve
        // blends from neck -> body_max_width -> tail_start_width.
        base = (t < 0.5) ? neck_width : tail_start_width,
        peak = body_max_width
    )
    base + (peak - base) * sin(clamp(t, 0, 1) * 180);

// Compute tail width tapering smoothly from the body to the tail tip.
// tail_taper_curve controls how quickly the tail narrows:
// lower values taper early, higher values keep thickness longer and then end fast.
function get_tail_width(x) =
    let (
        // Convert the world X coordinate into a local 0..1 tail progress value.
        t = clamp((x - body_length) / tail_length, 0, 1),
        curved_t = pow(t, tail_taper_curve)
    )
    max(0.4, tail_start_width * (1 - curved_t));

// Choose the correct width profile depending on x along the snake.
// This is the single width lookup used by the envelope, scales, eyes, and details.
function get_envelope_width(x) =
    (x <= 0) ? get_head_width(x) :
    (x <= body_length) ? get_zigzag_outer(x / body_length) : 
    get_tail_width(x);

// Compute head height at a given x coordinate, blending snout and head profile.
// The snout front is rounded as an ellipse, then the rest of the head blends up
// or down to the body height so the neck transition is smooth.
function get_head_height(x) =
    let(
        // zr is the rounded vertical radius at the snout. base_h keeps the
        // bottom portion from collapsing into a full half-circle.
        zr = snout_height * 0.45,
        base_h = snout_height - zr
    )
    (x <= snout_base_x) ? 
        base_h + zr * sqrt(max(0.001, 1 - pow((x - snout_base_x)/snout_length, 2))) :
    cosine_interp(snout_height, snake_height_eff, (x - snout_base_x) / (0 - snout_base_x));

// Choose the height profile for head, body, and tapered tail.
// The tail height scales with tail width so the tip becomes smaller in both axes.
function get_envelope_height(x) =
    (x <= 0) ? get_head_height(x) :
    (x <= body_length) ? snake_height_eff :
    max(1.5, snake_height_eff * (get_tail_width(x) / tail_start_width));

// --- GEOMETRY MODULES ---

// Create a solid head block for the initial shell before trimming.
// This is intentionally oversized. The final head shape comes from intersecting
// it with snake_envelope(), so this block only needs to cover the region where
// head material may exist.
module base_head() {
    translate([snout_tip_x - 1, -head_jaw_width, 0]) 
        cube([abs(snout_tip_x) + head_tail_anchor_length + 1, head_jaw_width*2, snake_height_eff + 15]);
}

// Create a solid tail block for the final shell before trimming.
// Like base_head(), this is just a rough material block. The tail taper comes
// from snake_envelope().
module base_tail() {
    translate([body_length - head_tail_anchor_length, -tail_start_width, 0]) 
        cube([tail_length + head_tail_anchor_length + 2, tail_start_width*2, snake_height_eff + 15]);
}

// Build the zig-zag flexible body using a series of hulls between cylinders.
// Each segment alternates from one side of the body envelope to the other.
// The line is thickened with cylinders and hull(), creating a continuous
// print-in-place spring wall rather than separate links.
module base_body() {
    for (i = [0:zig_zags_eff-1]) {
        // t1/t2 are normalized positions of the current segment endpoints.
        t1 = i / zig_zags_eff;
        t2 = (i+1) / zig_zags_eff;
        
        // Subtract half a wall on each side so the cylinder centerline stays
        // inside the outer envelope instead of poking through it.
        w1_center = get_zigzag_outer(t1) - wall_thickness_eff;
        w2_center = get_zigzag_outer(t2) - wall_thickness_eff;
        
        // Alternating endpoint sides create the zig-zag spring path.
        y1 = (i % 2 == 0) ? w1_center/2 : -w1_center/2;
        y2 = ((i+1) % 2 == 0) ? w2_center/2 : -w2_center/2;
        
        // Hull between two vertical cylinders turns a pair of points into a
        // printable thick beam with rounded ends.
        hull() {
            // The cylinders are taller than the snake height to ensure they fully intersect the envelope, preventing gaps in the final shell.
            translate([t1 * body_length, y1, 0]) cylinder(r=wall_thickness_eff/2, h=snake_height_eff+15, $fn=body_cylinder_fn);
            // Each cylinder is placed at the center of the zig-zag path, with a radius that creates the desired wall thickness. 
            // The hull then creates a smooth connection between them, forming the zig-zag body segments.
            translate([t2 * body_length, y2, 0]) cylinder(r=wall_thickness_eff/2, h=snake_height_eff+15, $fn=body_cylinder_fn);
        }
    }
}

// Build a single cross-section of the snake envelope at x with width and height.
// The cross-section has straight lower sides and a rounded dome. Adjacent
// sections are hulled together in snake_envelope() to form the full smooth shell.
module envelope_slice(x, w, h) {
    // Clamp dimensions so even very small tail slices still produce valid solids.
    w_eff = max(0.1, w);
    h_eff = max(0.1, h);
    
    // back_flatness creates a wider flat top before the rounded shoulders begin.
    flat_w_val = w_eff * back_flatness;
    curve_w = (w_eff - flat_w_val) / 2;
    
    // Scale the vertical wall height down on shorter slices, especially the tail.
    v_wall = vertical_wall_height * (h_eff / snake_height_eff);
    safe_v_wall = max(0.01, min(v_wall, h_eff));
    dome_h = max(0.01, h_eff - safe_v_wall);
    
    // Draw the 2D Y/Z profile, rotate it into the Y/Z plane, then extrude a
    // paper-thin slice along X so hull() can connect adjacent slices.
    translate([x, 0, 0])
    rotate([90, 0, 90])
    linear_extrude(0.01, center=true)
    union() {
        // Lower rectangular wall: flat sides make the model printable and stable.
        translate([-w_eff/2, 0]) square([w_eff, safe_v_wall + 0.01]);
        translate([0, safe_v_wall])
        if (back_flatness >= 0.99) {
            // Fully flat back requested: use a rectangle instead of curved shoulders.
            translate([-w_eff/2, 0]) square([w_eff, dome_h]);
        } else {
            // Rounded dome: hull a center flat strip with left/right quarter circles.
            hull() {
                // The center strip ensures the top remains flat across the middle portion of the back, while the circles create the rounded shoulders on either side.
                translate([-w_eff/2, 0]) square([w_eff, 0.01]);
                // The circles are scaled to create the rounded shoulders. The flat top is created by leaving the center portion of the 
                //circles out and only using the outer sides.
                translate([flat_w_val/2, 0]) scale([curve_w, dome_h]) intersection() { circle(r=1, $fn=profile_curve_fn); square([1, 1]); }
                // Mirror the circle to the other side for the opposite shoulder.
                translate([-flat_w_val/2, 0]) scale([curve_w, dome_h]) intersection() { circle(r=1, $fn=profile_curve_fn); translate([-1, 0]) square([1, 1]); }
            }
        }
    }
}

// Generate the full outer body envelope by hulling adjacent slices.
// This is the most expensive module in the file. If preview becomes slow, lower
// envelope_steps while designing and raise it. The final render can be done at a higher setting for a smoother shell.
module snake_envelope() {
    // The envelope is built by sampling a series of X positions along the snake, calculating the width and height at each point, 
    // and then hulling between adjacent slices to create a continuous shell.
    // Start a little before the snout tip to ensure the front of the head is fully captured in the shell, preventing gaps at the nose.
    min_x = snout_tip_x - 0.2;
    // Add a small margin to the tail end to ensure the final slice fully captures the tail tip, preventing gaps in the shell.
    max_x = body_length + tail_length + 0.2;
    // Ensure a minimum number of steps for a smooth shell, but allow increasing it for better quality at the cost of render time.
    steps = max(12, floor(envelope_steps));
    // dx is the distance between each sampled slice along the X axis. More steps means smaller dx and a smoother shell, but longer render times.
    dx = (max_x - min_x) / steps;
    
    // Loop through each slice position, calculate the local width and height, and hull between adjacent slices to build the full envelope.
    for (i=[0:steps-1]) {
        // x1 and x2 are the X positions of the current slice and the next slice. The hull will connect these two slices to create a segment of the shell.
        x1 = min_x + i*dx;
        x2 = x1 + dx;
        
        // Add a tiny width margin so the rough base solids are fully capture
        w1 = get_envelope_width(x1) + 0.1;
        w2 = get_envelope_width(x2) + 0.1;
        h1 = get_envelope_height(x1);
        h2 = get_envelope_height(x2);
        
        // Hull between two adjacent slices creates a smooth transition along the length of the snake. 
        // Each slice defines the cross-sectional shape at that point, and the hull connects them into a continuous shell.
        hull() {
            // Each slice is a thin extruded profile that defines the shape of the envelope at that X position. 
            // The hull then creates a smooth connection between them, forming the full 3D shell of the snake.
            envelope_slice(x1, w1, h1);
            // The next slice is placed at x2 with its own width and height, allowing the hull to create the smooth transition between them.
            envelope_slice(x2, w2, h2);
        }
    }
}

// Optional decorative scale coat.
// Scales are added on top of the envelope, then intersected with the base body

module scale_coat() {
    // X spacing is based on overlap so scales partially cover the previous row.
    x_step = scale_size * scale_overlap;
    // Avoid the very tip of the snout and the fragile tail end.
    start_x = snout_tip_x + (snout_length * 0.4); 
    end_x = body_length + tail_length - 4;

    // Loop through each X position along the snake where scales will be placed. 
    // The scales are arranged in rows that follow the changing width of the snake, creating a natural pattern.
    for (x = [start_x : x_step : end_x]) {
        // Query the actual envelope at this X so scale rows follow changing width.
        w = get_envelope_width(x);
        h = get_envelope_height(x);
        
        // Only add scales where the body is wide enough to support them. This prevents overcrowding and printing issues on the narrow tail and snout.
        if (w > 2.5) {
            // Recreate enough of the dome math to place each scale on the surface.
            flat_w_val = w * back_flatness;
            // curve_w is the horizontal distance from the flat top to the start of the curve. This is used to calculate the dome height and scale placement.
            curve_w = (w - flat_w_val) / 2;
            // safe_curve_w is a clamped version of curve_w to prevent invalid math when the body becomes very narrow. 
            // It ensures the scale placement math remains valid even on small tail slices.
            safe_curve_w = max(0.001, curve_w);
            // dome_h is the vertical height of the dome portion of the cross-section. It's the total height minus the vertical wall height.
            dome_h = max(0.01, h - vertical_wall_height);
            
            // Scales shrink near the narrow head/tail and grow near the body center.
            current_size = scale_size * clamp(w / body_max_width, 0.45, 1.1);
            y_span = w * 0.92; 
            num_y = max(3, round(y_span / (current_size * 0.75)));
            
            // Stagger every other X row to make the pattern look more organic.
            row_idx = round((x - start_x) / x_step);
            stagger = (row_idx % 2 == 0) ? 0.5 : 0;
            y_step = y_span / num_y;
            
            for (i = [0 : num_y - 1]) {
                // Convert row index to a Y position across the visible back.
                y_offset = (i + stagger) * y_step;
                y_pos = -y_span/2 + y_offset;
                abs_y = abs(y_pos);
                
                // Project the scale onto either the flat top or rounded side dome.
                is_flat = abs_y <= (flat_w_val/2 + 0.01);
                rel_y = abs_y - flat_w_val/2;
                safe_y = min(rel_y, safe_curve_w - 0.001);
                rad_val = max(0, 1 - pow(safe_y / safe_curve_w, 2));
                rel_z = dome_h * sqrt(rad_val);
                
                // Estimate the local surface normal so side scales tilt with the body.
                z_pos = is_flat ? (vertical_wall_height + dome_h) : (vertical_wall_height + rel_z); 
                NY = safe_y / pow(safe_curve_w, 2);
                NZ = rel_z / pow(dome_h, 2);
                side_theta = atan2(NY, NZ);
                theta = is_flat ? 0 : ((y_pos < 0) ? -side_theta : side_theta);
                
                if (z_pos > vertical_wall_height + 0.5) {
                    // Pitch scales slightly backward along X so they read as overlapping plates.
                    h_next = get_envelope_height(x + 2);
                    pitch_base = atan2(h - h_next, 2);
                    
                    translate([x, y_pos, z_pos])
                        rotate([theta, pitch_base - 10 - (current_size * 1.5), 0])
                        scale([1.1, 0.9, 0.55])
                        sphere(r=current_size/2, $fn=scale_sphere_fn);
                }
            }
        }
    }
}

// Calculate eye position and size based on head geometry so they stay properly placed even with extreme Customizer settings.
eye_x = snout_base_x + (flare_x - snout_base_x) * 0.4;
// eye_w and eye_h are used to position the eye sockets and visible eye spheres so they stay properly placed on the head even 
// as the head shape changes with Customizer adjustments.
eye_w = get_envelope_width(eye_x);
// eye_h is used to position the eye sockets vertically on the head, and eye_w is used to position them horizontally so they 
// stay in the correct place even as the head shape changes.
eye_h = get_envelope_height(eye_x);
// eye_socket_r is the radius of the spherical cutout for the eye socket. 
// It's based on head_jaw_width to keep it proportional to the overall head size, and is used in both the eye_cutouts and 
// internal_eye_structure modules to ensure the visible eye fits properly inside the socket.
eye_socket_r = head_jaw_width * 0.09;


// Cut the eye openings out of the head shell.
module eye_cutouts() {
    // The elongated eye socket is subtracted from the head. The colored eye
    // added later is slightly smaller and sits inside this pocket.
    module base_eye_shape() { scale([1.4, 0.65, 1.1]) sphere(r=eye_socket_r, $fn=eye_sphere_fn); }
    // Right side eye socket.
    translate([eye_x, eye_w/2 - eye_socket_r*0.2, eye_h*0.65])
        rotate([0, 10, 20]) base_eye_shape();
    // Left side eye socket, mirrored in Y.
    translate([eye_x, -eye_w/2 + eye_socket_r*0.2, eye_h*0.65])
        rotate([0, 10, -20]) base_eye_shape();
}

// Create the visible eye spheres and internal eye locking volume.
module internal_eye_structure() {
    // Right visible eye. The X expression is kept from the original model so
    // eye_horizontal_pos behaves like the existing Customizer control.
    translate([eye_x * eye_horizontal_pos/10, eye_w/2 - eye_socket_r*eye_depth_into_head, eye_h * eye_vertical_pos])
        rotate([0, 100, 100]) scale([1.2, 0.5, 0.9]) sphere(r=eye_socket_r*0.8, $fn=eye_sphere_fn);
    // Left visible eye.
    translate([eye_x * eye_horizontal_pos/10, -eye_w/2 + eye_socket_r * eye_depth_into_head, eye_h * eye_vertical_pos])
        rotate([0, 100, 100]) scale([1.2, 0.5, 0.9]) sphere(r=eye_socket_r*0.8, $fn=eye_sphere_fn);
        
    // Internal locking bulge supports the eye region from inside the head.
    translate([eye_x, 0, eye_h*0.65])
        rotate([90, 0, 0]) rotate([0, 0, 45])
        cylinder(d=eye_socket_r*1.6, h=eye_w*0.3, center=true, $fn=4);
}

module jaw_sever_cuts() {
    // mouth_front_x starts a little before the snout so the slit fully exits.
    mouth_front_x = snout_tip_x - 2;
    // mouth_back_x includes the taper fade so the subtraction ends cleanly.
    mouth_back_x = hx + lower_jaw_taper_fade_length;

    // Horizontal slit separating top from bottom lip.
    // The hull between two very thin cubes creates a long rectangular clearance
    // that follows the snout/head X direction. jaw_clearance is the print-in-
    // place air gap between upper and lower jaw.
    hull() {
        translate([mouth_front_x, 0, mouth_z_eval]) cube([0.1, head_jaw_width*2.5, jaw_clearance], center=true);
        translate([hx, 0, mouth_z_eval]) cube([0.1, head_jaw_width*2.5, jaw_clearance], center=true);
    }

    // Internal relief above the bottom skin. This removes the old visible underside gap
    // while leaving a thin living-hinge web tied into the lower jaw and head/body.
    if (living_hinge_relief_height > 0) {
        relief_width = max(0.1, get_envelope_width(hx) - living_hinge_side_skin_eff*2);
        translate([hx, 0, living_hinge_thickness_eff + living_hinge_relief_height/2])
            cube([living_hinge_length_eff + jaw_clearance*2, relief_width, living_hinge_relief_height], center=true);
             
    }

    // Smooth ramped thinning of the lower jaw into the living hinge.
    if (lower_jaw_taper_enabled && lower_jaw_taper_length > 0) {
        // Keep the taper inside the outer side walls unless side skin is set to 0.
        taper_width = max(0.1, get_envelope_width(hx) - max(0, lower_jaw_taper_side_skin)*2);
        taper_min_z = max(living_hinge_thickness_eff, abs(lower_jaw_taper_min_thickness));
        taper_height = max(0.01, mouth_z_eval - taper_min_z);

        // Hull three cross sections into a wedge-shaped clearance. This thins
        // the lower jaw near the hinge without cutting the outside silhouette.
        hull() {
            translate([hx - lower_jaw_taper_length, 0, mouth_z_eval])
                cube([0.1, taper_width, jaw_clearance], center=true);

            translate([hx + living_hinge_length_eff/2, 0, taper_min_z + taper_height/2])
                cube([0.1, taper_width, taper_height], center=true);

            translate([mouth_back_x, 0, mouth_z_eval])
                cube([0.1, taper_width, jaw_clearance], center=true);
        }
    }
}

// Add the print-in-place living hinge structure into the head and jaw.
module living_hinge_add() {
    color(body_color)
    intersection() {
        // Clip hinge pieces to the same outer envelope, so anchors cannot poke
        // through the rounded head shape.
        snake_envelope();
        union() {
            // Thin flexible web between jaw and head.
            translate([living_hinge_flex_cx, 0, living_hinge_thickness_eff/2])
                cube([living_hinge_length_eff + living_hinge_overlap_eff*2, living_hinge_width_eff, living_hinge_thickness_eff], center=true);

            // Anchor bonded to the lower jaw.
            translate([living_hinge_jaw_anchor_cx, 0, living_hinge_anchor_thickness_eff/2])
                cube([living_hinge_anchor_length_eff + living_hinge_overlap_eff, living_hinge_width_eff, living_hinge_anchor_thickness_eff], center=true);

            // Anchor bonded to the head/body side of the slit.
            translate([living_hinge_head_anchor_cx, 0, living_hinge_anchor_thickness_eff/2])
                cube([living_hinge_anchor_length_eff + living_hinge_overlap_eff, living_hinge_width_eff, living_hinge_anchor_thickness_eff], center=true);
        }
    }
}

// Helper for small custom tapered solids.
// p0..p3 are [x, z] points. The shape is extruded symmetrically along Y.
module y_extruded_quad(p0, p1, p2, p3, width) {
    // Build two copies of the 2D quad, one at each Y side.
    // Points are stored as [x, y, z] because polyhedron works in full 3D.
    polyhedron(
        points=[
            [p0[0], -width/2, p0[1]], [p1[0], -width/2, p1[1]], [p2[0], -width/2, p2[1]], [p3[0], -width/2, p3[1]],
            [p0[0],  width/2, p0[1]], [p1[0],  width/2, p1[1]], [p2[0],  width/2, p2[1]], [p3[0],  width/2, p3[1]]
        ],
        // Faces: back side, front side, then the four edges around the quad.
        faces=[
            [0, 1, 2, 3],
            [7, 6, 5, 4],
            [0, 4, 5, 1],
            [1, 5, 6, 2],
            [2, 6, 7, 3],
            [3, 7, 4, 0]
        ]
    );
}

// Add a lower lip extension to help the jaw gap follow the taper shape.
module upper_jaw_lip_add() {
    if (upper_jaw_lip_enabled && upper_jaw_lip_length > 0) {
        // Width follows the head envelope at the hinge so the lip does not
        // protrude through the outside walls.
        lip_width = max(0.1, get_envelope_width(hx) - max(0, upper_jaw_lip_side_skin)*2);
        taper_min_z = max(living_hinge_thickness_eff, abs(lower_jaw_taper_min_thickness));
        // X landmarks: front of lip, deepest/lowest point, and rear fade-out.
        lip_front_x = hx - upper_jaw_lip_length;
        // The lip peak is centered on the hinge for a natural bending motion, and the rear fades back towards the head to prevent a hard step.
        lip_peak_x = hx - living_hinge_length_eff/2;
        lip_back_x = hx + max(0.1, lower_jaw_taper_fade_length);
        // Z landmarks: lip top blends into upper jaw, lower values shape the mouth gap.
        lip_top_z = mouth_z_eval + jaw_clearance/2 + upper_jaw_lip_overlap;
        // The lip bottom is shaped by jaw_clearance and the taper minimum so it blends smoothly into the mouth gap without creating a hard edge or disappearing entirely.
        lip_front_bottom_z = mouth_z_eval + jaw_clearance/2;
        // The lip peak bottom is the lowest point of the lip, and is influenced by both the jaw clearance and the taper minimum to ensure it creates a 
        //smooth curve that follows the mouth gap without poking through the envelope.
        lip_peak_bottom_z = min(mouth_z_eval + jaw_clearance/2, taper_min_z + upper_jaw_lip_gap);
        lip_end_bottom_z = lip_top_z - 0.02;

        color(body_color)
        intersection() {
            // Clip the added lip to the same envelope as the main head.
            snake_envelope();
            union() {
                // Front sloped lip piece.
                y_extruded_quad(
                    [lip_front_x, lip_top_z],
                    [lip_peak_x, lip_top_z],
                    [lip_peak_x, lip_peak_bottom_z],
                    [lip_front_x, lip_front_bottom_z],
                    lip_width
                );

                // Rear fade piece, preventing a hard internal step.
                y_extruded_quad(
                    [lip_peak_x, lip_top_z],
                    [lip_back_x, lip_top_z],
                    [lip_back_x, lip_end_bottom_z],
                    [lip_peak_x, lip_peak_bottom_z],
                    lip_width
                );
            }
        }
    }
}

// Create nostril holes in the front snout area.
module nostril_cutouts() {
    // Position nostrils on the rounded snout by querying the local envelope.
    n_x = snout_tip_x + snout_length * 0.18;
    n_w = get_envelope_width(n_x);
    n_h = get_envelope_height(n_x);
    n_r = snout_width * 0.08;
    // Right nostril.
    translate([n_x, n_w/2 * 0.45, n_h*0.55]) sphere(r=n_r, $fn=16);
    // Left nostril.
    translate([n_x, -n_w/2 * 0.45, n_h*0.55]) sphere(r=n_r, $fn=16);
}

module tongue_geometry() {
    // Tongue sits exclusively in the lower space, avoiding ANY upper jaw intersections entirely.
    tongue_z = mouth_z_eval - 0.2; 
    // drop_dist sets how far the tongue descends before it runs along the bed.
    drop_dist = tongue_z - 0.5; 
    tongue_width = 2.0;
    
    color(tongue_color)
    translate([snout_tip_x, 0, tongue_z]) {
        // TONGUE ROOT / ANCHOR (Deep dovetail lock inside the lower jaw, fully support free)
        hull() {
            // The square/diamond cylinders make a mechanical key inside the lower jaw.
            // The slight Y rotation improves retention without requiring supports.
            translate([8, 0, -1.0]) rotate([0, 30 , 0]) rotate([0, 0, 45]) cylinder(d=tongue_width, h=0.5, center=true, $fn=4);
            translate([-0.0, 0, -0.6]) rotate([0, 90, 0]) rotate([0, 0, 45]) cylinder(d=tongue_width, h=0.5, center=true, $fn=4);
        }
        // Drop leg (Slopes down at graceful 45-degree angle to hit the build plate directly)
        hull() {
            // Start at the root.
            translate([-0.0, 0, -0.6]) rotate([0, 90, 0]) rotate([0, 0, 45]) cylinder(d=tongue_width, h=0.5, center=true, $fn=4);
            // End near the build plate so the tongue can print without support.
            translate([-drop_dist - 0.5, 0, -drop_dist - 0.6]) rotate([0, 90, 0]) rotate([0, 0, 45]) cylinder(d=tongue_width, h=0.5, center=true, $fn=4);
        }
        // Fork safely gliding flat across the build plate
        translate([-drop_dist - 0.5, 0, -drop_dist - 0.6]) {
            // Each fork is a hull from the center pad to a tiny tip cylinder.
            // Upper fork branch.
            hull() { translate([0, 0, 0]) cylinder(r=1.0, h=tongue_width, center=true, $fn=16); translate([-5, 3.5, 0]) cylinder(r=0.4, h=0.8, center=true, $fn=16); }
            // Lower fork branch.
            hull() { translate([0, 0, 0]) cylinder(r=1.0, h=tongue_width, center=true, $fn=16); translate([-5, -3.5, 0]) cylinder(r=0.4, h=0.8, center=true, $fn=16); }
        }
    }
}

// --- FINAL MASTER ASSEMBLY ---
// Assemble the full snake model with shell, cutouts, hinge, and details.
module raw_assembly() {
    union() {
        color(body_color)     
        difference() {
            // Step 1: Base unified external shell.
            // The rough blocks create material regions; the envelope trims them
            // into the final rounded snake. scale_coat() is optional and is
            // included inside this intersection so scales stay on the surface.
            intersection() {
                union() { base_head(); base_body(); base_tail(); }
                union() { snake_envelope(); if (enable_scales) scale_coat(); }
            }
            // Step 2: Slice out the jaw gap and detail pockets.
            // These are subtractive features that must be cut before adding
            // hinge/eyes/tongue.
            eye_cutouts();
            nostril_cutouts();
            jaw_sever_cuts();
        }
        
        // Step 3: Add the living hinge bridge and colorful details.
        // These are additive parts after the main shell cutouts.
        upper_jaw_lip_add();
        living_hinge_add(); 
        color(eye_color) internal_eye_structure();
        tongue_geometry();
    }
}

// Ensure the bottom of the model is cut flat for reliable first-layer adhesion.
// The cube starts at Z=0 and extends upward, removing any accidental geometry
// below the bed while preserving the full printable height.
intersection() {
    raw_assembly();
    translate([0, 0, snake_height_eff*1.5]) 
        cube([body_length*3, body_max_width*3, snake_height_eff*3], center=true);
}
