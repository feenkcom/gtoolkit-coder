Class {
	#name : #GtDiffFlatAptitude,
	#superclass : #GtDiffAptitude,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #initialization }
GtDiffFlatAptitude >> initialize [
	super initialize.
	
	self add: (BrLayoutResizerAptitude new
		inherit;
		inherit: GtDiffOldTextId;
		inherit: GtDiffNewTextId).

	self add: (self newTextLook // GtDiffOldTextId).
	self add: (self newTextLook // GtDiffNewTextId)
]

{ #category : #'instance creation' }
GtDiffFlatAptitude >> newTextLook [
	^ BrSizeAdjustmentAptitude new
		normal: [ :aStyle |
			aStyle
				padding: (BlInsets all: 10);
				do: [ :aWidget | aWidget aptitude glamorousCodeSize ]
				after: [  ] ];
		small: [ :aStyle |
			aStyle
				padding: (BlInsets all: 6);
				do: [ :aWidget | aWidget aptitude glamorousCodeSmallSize ]
				after: [  ] ];
		tiny: [ :aStyle |
			aStyle
				padding: (BlInsets all: 4);
				do: [ :aWidget | aWidget aptitude glamorousCodeTinySize ]
				after: [  ] ];
		mini: [ :aStyle |
			aStyle
				padding: (BlInsets all: 2);
				do: [ :aWidget | aWidget aptitude glamorousCodeMiniSize ]
				after: [  ] ]
]
