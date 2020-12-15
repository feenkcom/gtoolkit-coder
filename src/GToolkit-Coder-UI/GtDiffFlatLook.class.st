Class {
	#name : #GtDiffFlatLook,
	#superclass : #GtDiffLook,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #initialization }
GtDiffFlatLook >> initialize [
	super initialize.
	
	self add: (BrLayoutResizerLook new
		inherit;
		inherit: GtDiffOldTextId;
		inherit: GtDiffNewTextId).

	self add: (self newTextLook // GtDiffOldTextId).
	self add: (self newTextLook // GtDiffNewTextId)
]

{ #category : #'instance creation' }
GtDiffFlatLook >> newTextLook [
	^ BrSizeAdjustmentLook new
		normal: [ :aStyle |
			aStyle
				padding: (BlInsets all: 10);
				do: [ :aWidget | aWidget look glamorousCodeSize ] ];
		small: [ :aStyle |
			aStyle
				padding: (BlInsets all: 6);
				do: [ :aWidget | aWidget look glamorousCodeSmallSize ] ];
		tiny: [ :aStyle |
			aStyle
				padding: (BlInsets all: 4);
				do: [ :aWidget | aWidget look glamorousCodeTinySize ] ];
		mini: [ :aStyle |
			aStyle
				padding: (BlInsets all: 2);
				do: [ :aWidget | aWidget look glamorousCodeMiniSize ] ]
]
