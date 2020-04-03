Class {
	#name : #GtBehaviorHeaderDifferencePreviewElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'behavior',
		'difference',
		'definition'
	],
	#category : #'GToolkit-Coder-Behavior - UI'
}

{ #category : #initialization }
GtBehaviorHeaderDifferencePreviewElement >> behavior: aBehavior definition: aDefinition difference: aDifference [
	behavior := aBehavior.
	definition := aDefinition.
	difference := aDifference.		
	
	self initializeElements
]

{ #category : #initialization }
GtBehaviorHeaderDifferencePreviewElement >> buildDiff [
	| oldSource newSource |

	oldSource := (GtBehaviorDefinition fromBehavior: behavior) asDefinitionString.
	newSource := definition asDefinitionString.
	
	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: behavior
]

{ #category : #initialization }
GtBehaviorHeaderDifferencePreviewElement >> initialize [
	super initialize.
	
	self
		hMatchParent;
		vFitContent
]

{ #category : #initialization }
GtBehaviorHeaderDifferencePreviewElement >> initializeElements [
	| aDiff aLeftEditor aRightEditor |
	
	self removeChildren.
	
	aDiff := self buildDiff.
	
	aLeftEditor := BrEditor new
		beReadOnlyWithSelection;
		look: (BrGlamorousCodeEditorLook new glamorousCodeSmallSize) + BrShadowLook new;
		text: aDiff previousRopedText;
		margin: (BlInsets all: 5);
		background: Color white;
		matchParent.
		
	aRightEditor := BrEditor new
		beReadOnlyWithSelection;
		look: (BrGlamorousCodeEditorLook new glamorousCodeSmallSize) + BrShadowLook new;
		text: aDiff newRopedText;
		margin: (BlInsets all: 5);
		background: Color white;
		matchParent.
		
	self addChildren: { aLeftEditor . aRightEditor }
]
