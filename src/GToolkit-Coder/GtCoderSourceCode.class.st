"
I represent a source code of the ${class:GtSourceCoder}$. For performance reasons the computation of the actual source code in the coder is done lazily. I am to provide a necessary abstraction to support it
"
Class {
	#name : #GtCoderSourceCode,
	#superclass : #Object,
	#instVars : [
		'sourceText',
		'collapsedText',
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - converting' }
GtCoderSourceCode >> asCompiledMethodSourceCode: aCompiledMethod [
	^ (GtCoderCompiledMethodSourceCode new fromSourceCode: self) compiledMethod: aCompiledMethod
]

{ #category : #'api - converting' }
GtCoderSourceCode >> asExplicitSourceCode: aString [
	^ (GtCoderExplicitSourceCode new fromSourceCode: self) source: aString
]

{ #category : #private }
GtCoderSourceCode >> attachToCoder: aGtSourceCoder [
	sourceCoder := aGtSourceCoder
]

{ #category : #initialization }
GtCoderSourceCode >> buildCollapsedText [
	<return: #BlText>

	^ self subclassResponsibility
]

{ #category : #initialization }
GtCoderSourceCode >> buildSourceText [
	<return: #BlText>

	^ self subclassResponsibility
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> collapsedText [
	<return: #BlText>

	^ collapsedText ifNil: [ collapsedText := self buildCollapsedText ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> collapsedTextDo: aBlock [
	"Evaluate a given block with my source code if present"

	^ collapsedText ifNotNil: aBlock
]

{ #category : #'api - changes' }
GtCoderSourceCode >> currentSourceString: aString [
	"Set a new source text"

	self sourceText
		deleteAll;
		insertString: aString asString at: 0
]

{ #category : #private }
GtCoderSourceCode >> detachFromCoder: aGtSourceCoder [
	sourceCoder := nil
]

{ #category : #initialization }
GtCoderSourceCode >> fromSourceCode: aGtCoderSourceCode [
	sourceText := nil.
	collapsedText := nil.

	aGtCoderSourceCode sourceTextDo: [ :aSourceText | sourceText := aSourceText ].
	aGtCoderSourceCode collapsedTextDo: [ :aCollapsedText | collapsedText := aCollapsedText ].
]

{ #category : #'api - testing' }
GtCoderSourceCode >> hasCollapsedText [
	<return: #Boolean>

	^ collapsedText notNil
]

{ #category : #'api - testing' }
GtCoderSourceCode >> hasSourceText [
	<return: #Boolean>

	^ sourceText notNil
]

{ #category : #'api - testing' }
GtCoderSourceCode >> isModified [
	^ self subclassResponsibility
]

{ #category : #'private - hooks' }
GtCoderSourceCode >> onTextModified [
	sourceCoder ifNotNil: [ :aSourceCoder | aSourceCoder textModified ]
]

{ #category : #'api - changes' }
GtCoderSourceCode >> resetCollapsedText [
	"Remove the cached collapsed text forcing it to be recomputed next time it is accessed"
	
	collapsedText := nil
]

{ #category : #'api - changes' }
GtCoderSourceCode >> resetSourceText [
	"Remove the cached source text forcing it to be recomputed next time it is accessed"

	sourceText ifNotNil: [ :aPreviousText | aPreviousText unsubscribe: self ].
	sourceText := nil
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceString [
	"Return a string representation of the current source text"
	<return: #String>
	
	^ self sourceText asString
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceText [
	<return: #BlText>

	^ sourceText ifNil: [
		sourceText := self buildSourceText.
		sourceText when: BlTextStringsInserted send: #onTextModified to: self.
		sourceText when: BlTextsDeleted send: #onTextModified to: self.
		sourceText ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code if present"

	^ sourceText ifNotNil: aBlock
]
