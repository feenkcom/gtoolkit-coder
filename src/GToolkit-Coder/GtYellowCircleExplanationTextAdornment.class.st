Class {
	#name : #GtYellowCircleExplanationTextAdornment,
	#superclass : #Object,
	#instVars : [
		'identifier'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'as yet unclassified' }
GtYellowCircleExplanationTextAdornment class >> forIdentifier: anIdentifier [
	| circleElement |
	
	circleElement := BlElement new
				geometry: BlEllipse new;
				size: 3@3;
				margin: (BlInsets top: 7);
				look: (GtExplainerTargetLook new explanationModel: anIdentifier).
	^ BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: circleElement.
		
]
