Class {
	#name : #GtYellowCircleExplanationTextAdornment,
	#superclass : #Object,
	#instVars : [
		'identifier'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #accessing }
GtYellowCircleExplanationTextAdornment class >> forIdentifier: anIdentifier [
	self forIdentifier: anIdentifier withSize: 5.
		
]

{ #category : #'as yet unclassified' }
GtYellowCircleExplanationTextAdornment class >> forIdentifier: anIdentifier withSize: aSize [
	| circleElement |
	
	circleElement := BlElement new
				geometry: BlEllipse new;
				size: aSize@aSize;
				look: (GtExplainerTargetLook new explanationModel: anIdentifier).
	^ BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: circleElement.
]
