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
	| circleElement |
	
	circleElement := BlElement new
				geometry: BlEllipse new;
				size: 5@5;
				look: (GtExplainerTargetLook new explanationModel: anIdentifier).
	^ BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: circleElement.
		
]
