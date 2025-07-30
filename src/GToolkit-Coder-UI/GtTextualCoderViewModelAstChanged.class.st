Class {
	#name : #GtTextualCoderViewModelAstChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'ast'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelAstChanged >> ast [
	^ ast
]

{ #category : #accessing }
GtTextualCoderViewModelAstChanged >> ast: anObject [
	ast := anObject
]
