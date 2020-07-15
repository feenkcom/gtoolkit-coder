"
I represent a source code of the ${class:GtSourceCoder}$. For performance reasons the computation of the actual source code in the coder is done lazily. I am to provide a necessary abstraction to support it
"
Class {
	#name : #GtCoderSourceCode,
	#superclass : #Object,
	#instVars : [
		'sourceText',
		'collapsedText'
	],
	#category : #'GToolkit-Coder-Coders'
}

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

{ #category : #'api - changes' }
GtCoderSourceCode >> resetCollapsedText [
	"Remove the cached collapsed text forcing it to be recomputed next time it is accessed"
	
	collapsedText := nil
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

	^ sourceText ifNil: [ sourceText := self buildSourceText ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code if present"

	^ sourceText ifNotNil: aBlock
]
