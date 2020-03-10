Class {
	#name : #GtZeroSizeCircleExplanationTextAdornment,
	#superclass : #Object,
	#instVars : [
		'identifier'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'as yet unclassified' }
GtZeroSizeCircleExplanationTextAdornment class >> forIdentifier: anIdentifier [
	| circleElement |
	
	circleElement := BlElement new
				geometry: BlEllipse new;
				size: 0@0;
				margin: (BlInsets top: 7);
				look: (GtExplainerTargetLook new explanationModel: anIdentifier).
	^ BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: circleElement.
]
