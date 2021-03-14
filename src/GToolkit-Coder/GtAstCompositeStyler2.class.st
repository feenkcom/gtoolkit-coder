Class {
	#name : #GtAstCompositeStyler2,
	#superclass : #GtAstStyler,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'api - styling' }
GtAstCompositeStyler2 >> extraStyle: aText ast: theAst [
	self stylers do: [ :eachStyler | eachStyler extraStyle: aText ast: theAst ]
]

{ #category : #'api - styling' }
GtAstCompositeStyler2 >> style: aText ast: theAst [
	self stylers do: [ :eachStyler |
		[ eachStyler style: aText ast: theAst ]
			on: Error
			do: [ :anError |
				NonInteractiveTranscript stdout
					nextPutAll: '[';
					nextPutAll: eachStyler class name;
					nextPutAll: '] ';
					print: anError;
					cr.
				
				anError emit ] ]
]

{ #category : #accessing }
GtAstCompositeStyler2 >> stylers [
	^ stylers ifNil: [ #() ]
]

{ #category : #accessing }
GtAstCompositeStyler2 >> stylers: anObject [
	stylers := anObject
]
