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
	self stylers do: [ :eachStyler |
		BlTextStylerTelemetry
			timeSync: [ 'Extra style using ', eachStyler class name ]
			during: [ eachStyler extraStyle: aText ast: theAst ] ]
]

{ #category : #'api - styling' }
GtCoderAstCompositeStyler >> style: aText ast: theAst [
	self stylers do: [ :eachStyler |
		[
			BlTextStylerTelemetry
				timeSync: [ 'Style using ', eachStyler class name ]
				during: [ eachStyler style: aText ast: theAst ] ]
			on: Error
			do: [ :anError |
				BlTextStylerTelemetry
					timeSync: [ 'Handle an error in ', eachStyler class name ]
					during: [
						anError emit.
						
						NonInteractiveTranscript stdout
							nextPutAll: '[';
							nextPutAll: ((anError signalerContext findContextSuchThat: [ :eachContext | eachContext contextClass = eachStyler class ])
								ifNil: [ eachStyler class name ]
								ifNotNil: [ :aContext | aContext method printString ]) ;
							nextPutAll: '] ';
							print: anError;
							cr ] ] ]
]

{ #category : #accessing }
GtCoderAstCompositeStyler >> stylers [
	^ stylers ifNil: [ #() ]
]

{ #category : #accessing }
GtCoderAstCompositeStyler >> stylers: anObject [
	stylers := anObject
]
