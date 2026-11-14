Class {
	#name : #GtDiffAptitude,
	#superclass : #BrAptitude,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #initialization }
GtDiffAptitude >> initialize [
	super initialize.
	{GtDiffOldTextId.
		GtDiffNewTextId.
		GtDiffOldLabelId.
		GtDiffNewLabelId} do: [ :anId | self add: self newTextPaddingLook // anId ]
]

{ #category : #private }
GtDiffAptitude >> newTextPaddingLook [
	^ BrSizeAdjustmentAptitude new
		normal: [ :style | style padding: (BlInsets all: 10) ];
		small: [ :style | style padding: (BlInsets all: 6) ];
		tiny: [ :style | style padding: (BlInsets all: 4) ];
		mini: [ :style | style padding: (BlInsets all: 2) ]
]
