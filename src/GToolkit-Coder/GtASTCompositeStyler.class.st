Class {
	#name : #GtASTCompositeStyler,
	#superclass : #GtASTStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #styling }
GtASTCompositeStyler >> extraStyle: aText ast: ast [
	self stylers do: [ :each | each extraStyle: aText ast: ast ]
]

{ #category : #styling }
GtASTCompositeStyler >> style: aText ast: ast [
	self stylers do: [ :each |
		[ each style: aText ast: ast ]
			on: Error
			do: [ :anError | anError emit ] ]
]

{ #category : #accessing }
GtASTCompositeStyler >> stylers [
	^ stylers ifNil: [ #() ]
]

{ #category : #accessing }
GtASTCompositeStyler >> stylers: aCollection [
	stylers := aCollection
]
