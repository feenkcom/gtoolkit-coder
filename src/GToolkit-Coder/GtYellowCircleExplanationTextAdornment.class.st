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
				size: 5@5;
				background: Color red;
				look: (GtExplainerTargetLook new explanationModel: anIdentifier).
	^ BrTextAdornmentDynamicAttribute new
				beReplace;
				stencil: circleElement.
		
]
