Class {
	#name : #GtCoderAstCompositeStyler,
	#superclass : #GtCoderAstStyler,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'as yet unclassified' }
GtCoderAstCompositeStyler >> = anObject [
	^self class == anObject class and: [self stylers = anObject stylers]
]

{ #category : #'api - styling' }
GtCoderAstCompositeStyler >> extraStyle: aText ast: theAst [
	self stylers do: [ :eachStyler |
		BlTextStylerTelemetry
			time: [ 'Extra style using ', eachStyler class name ]
			during: [ eachStyler extraStyle: aText ast: theAst ] ]
]

{ #category : #'as yet unclassified' }
GtCoderAstCompositeStyler >> hash [
	^ self class hash xor: self stylers hash
]

{ #category : #'api - styling' }
GtCoderAstCompositeStyler >> style: aText ast: theAst [
	self stylers do: [ :eachStyler |
		[
			GtCoderAstStyler telemetryComputationStartSignal: eachStyler.
		
			BlTextStylerTelemetry
				time: [ 'Style using ', eachStyler class name ]
				during: [ eachStyler style: aText ast: theAst ].
				
			GtCoderAstStyler telemetryComputationEndSignal: eachStyler.
		]
			on: Error
			do: [ :anError |
				GtCoderAstStyler telemetryComputationEndSignal: eachStyler.
			
				BlTextStylerTelemetry
					time: [ 'Handle an error in ', eachStyler class name ]
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
