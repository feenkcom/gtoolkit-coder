Class {
	#name : #GtDiffShadowAptitude,
	#superclass : #GtDiffAptitude,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #initialization }
GtDiffShadowAptitude >> initialize [
	super initialize.
	
	self add: (BrLayoutResizerAptitude new
		inherit;
		inherit: GtDiffOldTextId;
		inherit: GtDiffNewTextId).

	self add: (BrSizeAdjustmentAptitude new
		normal: [ :aStyle | aStyle padding: (BlInsets all: 10) ];
		small: [ :aStyle | aStyle padding: (BlInsets all: 8) ];
		tiny: [ :aStyle | aStyle padding: (BlInsets all: 6) ];
		mini: [ :aStyle | aStyle padding: (BlInsets all: 6) ]).

	self add: (self newTextLook // GtDiffOldTextId).
	self add: (self newShadowLook // GtDiffOldTextId).
	
	self add: (self newSeparatorLook // GtDiffSeparatorId).
	
	self add: (self newTextLook // GtDiffNewTextId).
	self add: (self newShadowLook // GtDiffNewTextId)
]

{ #category : #initialization }
GtDiffShadowAptitude >> newSeparatorLook [
	^ BrSizeAdjustmentAptitude new
		normal: [ :aStyle | aStyle hExact: 40 ];
		small: [ :aStyle | aStyle hExact: 25 ];
		tiny: [ :aStyle | aStyle hExact: 20 ];
		mini: [ :aStyle | aStyle hExact: 10 ]
]

{ #category : #initialization }
GtDiffShadowAptitude >> newShadowLook [
	^ BrStyleCommonAptitude new
		default: [ :aStyle |
			aStyle
				background: Color white;
				effect: BrGlamorousShadowEffect new ];
		yourself
]

{ #category : #initialization }
GtDiffShadowAptitude >> newTextLook [
	^ BrSizeAdjustmentAptitude new
		normal: [ :aStyle |
			aStyle
				padding: (BlInsets all: 10);
				do: [ :aWidget | aWidget aptitude glamorousCodeSize ] ];
		small: [ :aStyle |
			aStyle
				padding: (BlInsets all: 6);
				do: [ :aWidget | aWidget aptitude glamorousCodeSmallSize ] ];
		tiny: [ :aStyle |
			aStyle
				padding: (BlInsets all: 4);
				do: [ :aWidget | aWidget aptitude glamorousCodeTinySize ] ];
		mini: [ :aStyle |
			aStyle
				padding: (BlInsets all: 2);
				do: [ :aWidget | aWidget aptitude glamorousCodeMiniSize ] ]
]
