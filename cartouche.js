const paletteGlyphs = Array.from(document.querySelectorAll('palette glyph'));
const cartoucheGlyphs = Array.from(document.querySelectorAll('cartouche glyph'));
// TODO: maintain cartouche glyphs in a separate array

let clickSource = null;
let dragSource = null;

const isPaletteGlyph = (target) => {
    return paletteGlyphs.indexOf(target) !== -1;
}

const isCartoucheGlyph = (target) => {
    return cartoucheGlyphs.indexOf(target) !== -1;
}

const isGlyphUsed = (glyph) => {
    console.assert(isPaletteGlyph(glyph) || isCartoucheGlyph(glyph));

    return cartoucheGlyphs.find((cartoucheGlyph) => cartoucheGlyph.dataset.value === glyph.dataset.value) !== undefined;
};

const swapGlyphs = (source, target) => {
    console.assert(isCartoucheGlyph(source));
    console.assert(isCartoucheGlyph(target));

    if (source.dataset.value === target.dataset.value) { return false; }
    if (source.dataset.value === undefined) {
        source.dataset.value = target.dataset.value;
        delete target.dataset.value;
        return true;
    }
    if (target.dataset.value === undefined) {
        target.dataset.value = source.dataset.value;
        delete source.dataset.value;
        return true;
    }

    [source.dataset.value, target.dataset.value] = [target.dataset.value, source.dataset.value];
    return true;
}

const clearGlyph = (glyph) => {
    console.assert(isPaletteGlyph(glyph) || isCartoucheGlyph(glyph));

    const glyphValue = glyph.dataset.value;
    if (glyphValue === undefined) { return false; }

    cartoucheGlyphs.forEach((cartoucheGlyph) => {
        if (cartoucheGlyph.dataset.value === glyphValue) {
            delete cartoucheGlyph.dataset.value;
        }
    });

    paletteGlyphs.forEach((paletteGlyph) => {
        if (paletteGlyph.dataset.value === glyphValue) {
            paletteGlyph.classList.remove('used');
        }
    });

    return true;
}

const assignGlyph = (paletteGlyph, cartoucheGlyph) => {
    console.assert(isPaletteGlyph(paletteGlyph));
    console.assert(isCartoucheGlyph(cartoucheGlyph));

    if (paletteGlyph.dataset.value === cartoucheGlyph.dataset.value) { return false; }

    clearGlyph(paletteGlyph);
    clearGlyph(cartoucheGlyph);

    cartoucheGlyph.dataset.value = paletteGlyph.dataset.value;
    paletteGlyph.classList.add('used');

    return true;
}

const tryCommand = function (source, target) {
    if (source === null) { return false; }
    if (target === null) {
        if (isPaletteGlyph(source)) {
            new Audio(invalidCommandAudio.src).play();
            return false;
        }
        if (isCartoucheGlyph(source)) {
            new Audio(clearGlyphAudio.src).play();
            return clearGlyph(source);
        }
        return false;
    }
    if (source === target) { return tryClicking(target); }

    // Can't customize the palette.
    if (isPaletteGlyph(source) && isPaletteGlyph(target)) {
        new Audio(invalidCommandAudio.src).play();
        return false;
    }

    if (isCartoucheGlyph(source) && isCartoucheGlyph(target)) {
        new Audio(assignGlyphAudio.src).play();
        return swapGlyphs(source, target);
    }

    if (isPaletteGlyph(source) && isCartoucheGlyph(target)) {
        if (target.dataset.value === undefined) {
            new Audio(assignGlyphAudio.src).play();
            return assignGlyph(source, target);
        }

        new Audio(invalidCommandAudio.src).play();
        return false;
    }
    if (isCartoucheGlyph(source) && isPaletteGlyph(target)) {
        new Audio(invalidCommandAudio.src).play();
        return false;
    }

    console.assert(false);
}

const setClickSource = function (source) {
    if (isPaletteGlyph(source)) {
        console.assert(!isGlyphUsed(source));
    } else if (isCartoucheGlyph(source)) {
        // Can't select an empty glyph.
        if (source.dataset.value === undefined) { return false; }
    } else {
        console.assert(false);
    }
        
    clickSource = source;
    clickSource.classList.add('selected');
    showValidTargets(clickSource);

    return true;
}

const clearClickSource = function () {
    if (isPaletteGlyph(clickSource)) {
        console.assert(!isGlyphUsed(clickSource));
    } else if (isCartoucheGlyph(clickSource)) {
        console.assert(clickSource.dataset.value !== undefined);
    } else {
        console.assert(false);
    }

    hideValidTargets();
    clickSource.classList.remove('selected');
    clickSource = null;

    return true;
}

const tryClicking = function (target) {
    if (clickSource === null) {
        new Audio(selectGlyphAudio.src).play();
        return setClickSource(target);
    }

    const source = clickSource;
    const clearResult = clearClickSource();

    if (source === target) {
        new Audio(unselectGlyphAudio.src).play();
        return clearResult;
    }

    if (isCartoucheGlyph(source) && target === null) {
        new Audio(clearGlyphAudio.src).play();
        const commandResult = clearGlyph(source);
        return clearResult || commandResult;
    }

    if (isPaletteGlyph(source) && isPaletteGlyph(target) && !isGlyphUsed(target)) {
        // As a shortcut, switch the clickSource instead of doing nothing.
        new Audio(selectGlyphAudio.src).play();
        const setResult = setClickSource(target);
        return clearResult || setResult;
    }

    const commandResult = tryCommand(source, target);
    return clearResult || commandResult;
}

const showValidTargets = (source) => {
    if (isPaletteGlyph(source)) {
        cartoucheGlyphs.forEach((cartoucheGlyph) => {
            cartoucheGlyph.classList.toggle('valid-target', cartoucheGlyph.dataset.value === undefined);
        });
        return true;  // TODO: Only return true if there are valid targets.
    } else if (isCartoucheGlyph(source)) {
        cartoucheGlyphs.forEach((cartoucheGlyph) => {
            cartoucheGlyph.classList.toggle('valid-target', cartoucheGlyph.dataset.value !== source.dataset.value);
        });
        return true;  // TODO: Only return true if there are valid targets.
    } else {
        console.assert(false);
    }
}

const hideValidTargets = () => {
    paletteGlyphs.forEach((paletteGlyph) => {
        paletteGlyph.classList.remove('valid-target');
    });
    cartoucheGlyphs.forEach((cartoucheGlyph) => {
        cartoucheGlyph.classList.remove('valid-target');
    });
    return true;  // TODO: Only return true if we hid any valid targets.
}

const startDragging = (source) => {
    if (isPaletteGlyph(source)) {
        console.assert(!isGlyphUsed(source));
    } else if (isCartoucheGlyph(source)) {
        console.assert(source.dataset.value !== undefined);
    } else {
        console.assert(false);
    }

    dragSource = source;
    dragSource.classList.add('dragged');
    showValidTargets(dragSource);

    // TODO: create mock drag object
    return true;
};

const stopDragging = () => {
    if (isPaletteGlyph(dragSource)) {
        console.assert(!isGlyphUsed(dragSource));
    } else if (isCartoucheGlyph(dragSource)) {
        console.assert(dragSource.dataset.value !== undefined);
    } else {
        console.assert(false);
    }

    // TODO: destroy mock drag object
    hideValidTargets();
    dragSource.classList.remove('dragged');
    dragSource = null;

    return true;
}

const tryDropping = (target) => {
    if (dragSource === null) { return false; }

    const source = dragSource;
    const dragResult = stopDragging();

    if (source === target) {
        const selectResult = tryClicking(target);
        return dragResult || selectResult;
    } else {
        const dropResult = tryCommand(source, target);
        return dragResult || dropResult;
    }
};

paletteGlyphs.forEach((paletteGlyph) => {
    paletteGlyph.addEventListener('mousedown', (e) => {
        if (clickSource === null) {
            if (!isGlyphUsed(paletteGlyph)) {
                startDragging(paletteGlyph);
            } else {
                new Audio(invalidCommandAudio.src).play();
            }
        } else {
            tryClicking(paletteGlyph);
        }
        e.stopPropagation();
    });
    paletteGlyph.addEventListener('mouseup', (e) => {
        tryDropping(paletteGlyph);
        e.stopPropagation();
    });

    // TODO: implement hover
});

cartoucheGlyphs.forEach((cartoucheGlyph) => {
    cartoucheGlyph.addEventListener('mousedown', (e) => {
        if (clickSource === null) {
            if (cartoucheGlyph.dataset.value !== undefined) {
                startDragging(cartoucheGlyph);
            } else {
                new Audio(invalidCommandAudio.src).play();
            }
        } else {
            tryClicking(cartoucheGlyph);
        }
        e.stopPropagation();
    });
    cartoucheGlyph.addEventListener('mouseup', (e) => {
        tryDropping(cartoucheGlyph);
        e.stopPropagation();
    });

    // TODO: implement hover
});

document.addEventListener('mousedown', () => {
    if (clickSource !== null) {
        tryClicking(null);
    }
});

document.addEventListener('mouseup', () => {
    if (dragSource !== null) {
        tryDropping(null);
    }
    if (clickSource !== null) {
        clearClickSource();
    }
});

document.body.addEventListener('mouseleave', () => {
    if (dragSource !== null) {
        stopDragging();
    }
});

document.querySelector('button').addEventListener('click', () => {
    const buffer = new ArrayBuffer(4 + 12);
    (new DataView(buffer, 0, 4)).setUint32(0, parseInt(document.getElementById('seed').value, 10), true);
    cartoucheGlyphs.forEach((cartoucheGlyph, index) => {
        const glyphValue = (cartoucheGlyph.dataset.value !== undefined) ? parseInt(cartoucheGlyph.dataset.value, 10) : 0;
        (new DataView(buffer, 4, 12)).setUint8(index, glyphValue, true);
    });

    const payload = Array.from(new Uint8Array(buffer)).map((c) => String.fromCharCode(c)).join("");
    navigator.clipboard.writeText(btoa(payload))
        .then(() => {
            console.log(btoa(payload));
            alert("Sorry! The solver backend is not exposed via HTTP, but I've copied the request payload to your clipboard.\n\n(It's also been logged to your browser console.)");
        });
});
