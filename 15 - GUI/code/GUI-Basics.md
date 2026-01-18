# SuperCollider GUI Basics

---

## Slide 1: Windows and Basic Controls

### Creating Windows
```supercollider
var win = Window("Title", Rect(left, top, width, height));
win.front;  // Display the window
```

### Essential Controls
- **StaticText**: Display text (titles, labels, dynamic content)
- **Button**: Interactive control with multiple states
- **Slider**: Continuous value control (0.0 to 1.0)
- **NumberBox**: Display and edit numerical values

### Key Pattern
Connect controls with `.action`:
```supercollider
slider.action = {|s| numberBox.value = s.value };
```

**Remember**: Use `var` declarations for all GUI variables.

---

## Slide 2: Layouts

### Three Main Layout Types

**FlowLayout** - Auto-wrapping elements
- Use: `win.view.decorator = FlowLayout(bounds, margin, gap)`
- Elements flow left-to-right, wrap to next line
- Good for: Multiple similar controls (buttons, knobs)

**HLayout** - Horizontal rows
- Use: `win.layout = HLayout(element1, element2, ...)`
- Elements stretch to fill available width
- Use `nil` for stretchable space

**VLayout** - Vertical columns
- Use: `win.layout = VLayout(element1, element2, ...)`
- Elements stretch to fill available height
- Stack controls vertically

### Nesting
Combine layouts for complex arrangements:
```supercollider
VLayout(
    HLayout(button1, button2),
    HLayout(button3, button4)
)
```

---

## Slide 3: EZSlider and Sound Control

### EZSlider - All-in-One Control
Combines StaticText + Slider + NumberBox:
```supercollider
EZSlider(parent, size, "Label", \freq, 
    action: {|ez| synth.set(\freq, ez.value)},
    labelWidth: 80
)
```

### Controlling Synths
1. **Create synth** with gate for proper cleanup
2. **Connect slider** to synth parameters via `.set`
3. **Free on close**: `win.onClose = { synth.free }`

### Value Mapping
Scale slider values (0.0-1.0) to useful ranges:
```supercollider
var freq = slider.value.linexp(0, 1, 200, 2000);
```
- `.linlin` - linear to linear
- `.linexp` - linear to exponential

---

## Slide 4: Routines and defer

### The Problem
GUI updates must happen on the **AppClock**, but audio routines run on different clocks.

### The Solution: defer{}
Wrap GUI updates in `defer{}` when calling from Routines:
```supercollider
Routine({
    10.do {|i|
        defer{ textView.string = i.asString };
        0.5.wait;
    };
}).play;
```

### Animation with UserView
Enable real-time drawing:
```supercollider
view.animate_(true);
view.frameRate_(60);
view.drawFunc_({ /* drawing code */ });
```

**Key Rule**: Any GUI update from a Routine or Task needs `defer{}`.

---

## Slide 5: UserView, Pen, and OSC

### Custom Drawing with Pen
**UserView** provides a canvas, **Pen** draws shapes:
```supercollider
view.drawFunc = {
    Pen.fillColor = Color.red;
    Pen.fillOval(Rect(x, y, width, height));
    Pen.strokeColor = Color.black;
    Pen.line(x1@y1, x2@y2);
    Pen.stroke;
};
```

### Mouse Interaction
```supercollider
view.mouseDownAction = {|v, x, y| 
    /* handle click at x, y */
};
```

### OSC Communication
Send data from server to GUI:
```supercollider
// In SynthDef:
SendReply.kr(Impulse.kr(30), '/tag', value);

// In GUI:
OSCdef(\name, {|msg|
    defer{ slider.value = msg[3] };
}, '/tag');
```

**Always** use `defer{}` when updating GUI from OSC!

---

## Quick Reference Card

| Task | Pattern |
|------|---------|
| Create window | `var win = Window("Title", Rect(...))` |
| Show window | `win.front` |
| Connect controls | `control.action = {|c| /* use c.value */ }` |
| Update from Routine | `defer{ control.value = newValue }` |
| Control synth | `synth.set(\param, value)` |
| Clean up | `win.onClose = { synth.free }` |
| Custom drawing | `view.drawFunc = { Pen.fillOval(...) }` |
| OSC to GUI | `OSCdef(\name, {|msg| defer{...} }, '/tag')` |
