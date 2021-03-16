Class {
	#name : #GtCoderAstCompositeStyler,
	#superclass : #GtCoderAstStyler,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'api - styling' }
GtCoderAstCompositeStyler >> extraStyle: aText ast: theAst [
	self stylers do: [ :eachStyler | eachStyler extraStyle: aText ast: theAst ]
]

{ #category : #'api - styling' }
GtCoderAstCompositeStyler >> style: aText ast: theAst [
	self stylers do: [ :eachStyler |
		[ eachStyler style: aText ast: theAst ]
			on: Error
			do: [ :anError |
				anError emit.
	
				NonInteractiveTranscript stdout
					nextPutAll: '[';
					nextPutAll: eachStyler class name;
					nextPutAll: '] ';
					print: anError;
					cr ] ]
]

{ #category : #accessing }
GtCoderAstCompositeStyler >> stylers [
	^ stylers ifNil: [ #() ]
]

{ #category : #accessing }
GtCoderAstCompositeStyler >> stylers: anObject [
	stylers := anObject
]
