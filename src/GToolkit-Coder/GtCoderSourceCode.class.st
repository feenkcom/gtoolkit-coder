"
I represent a source code of the ${class:GtSourceCoder}$. For performance reasons the computation of the actual source code in the coder is done lazily. I am to provide a necessary abstraction to support it
"
Class {
	#name : #GtCoderSourceCode,
	#superclass : #Object,
	#instVars : [
		'monitor',
		'sourceText',
		'collapsedText'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - text' }
GtCoderSourceCode >> appendString: aString [
	self critical: [ self sourceText appendString: aString ]
]

{ #category : #'api - text' }
GtCoderSourceCode >> appendText: aText [
	self critical: [ self sourceText append: aText ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> asAstCacheKey [
	^ self subclassResponsibility
]

{ #category : #'api - converting' }
GtCoderSourceCode >> asCompiledMethodSourceCode: aCompiledMethod [
	^ (GtCoderCompiledMethodSourceCode new fromSourceCode: self) compiledMethod: aCompiledMethod
]

{ #category : #'api - converting' }
GtCoderSourceCode >> asExplicitSourceCode: aString [
	^ (GtCoderExplicitSourceCode new fromSourceCode: self) source: aString
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

	^ self critical: [ collapsedText ifNil: [ collapsedText := self buildCollapsedText ] ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> collapsedTextDo: aBlock [
	"Evaluate a given block with my source code if present"

	^ self critical: [ collapsedText ifNotNil: aBlock ]
]

{ #category : #'mutual exclusion' }
GtCoderSourceCode >> critical: aBlock [
	^ monitor critical: aBlock
]

{ #category : #'api - text' }
GtCoderSourceCode >> currentSourceString: aString [
	"Set a new source text"

	self critical: [ sourceText := aString asRopedText ]
]

{ #category : #'api - text' }
GtCoderSourceCode >> currentSourceText: aText [
	"Set a new source text"

	self critical: [ sourceText := aText copyWithoutExternalReferences ]
]

{ #category : #'api - text' }
GtCoderSourceCode >> delete: aFromIndex to: aToIndex [
	self sourceTextDo: [ :aText | aText delete: aFromIndex to: aToIndex ]
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

	^ self critical: [ collapsedText notNil ]
]

{ #category : #'api - testing' }
GtCoderSourceCode >> hasSourceText [
	<return: #Boolean>

	^ self critical: [ sourceText notNil ]
]

{ #category : #initialization }
GtCoderSourceCode >> initialize [
	super initialize.
	
	monitor := Monitor new
]

{ #category : #'api - testing' }
GtCoderSourceCode >> isModified [
	^ self subclassResponsibility
]

{ #category : #'api - text' }
GtCoderSourceCode >> replaceFrom: aFromIndex to: aToIndex withString: aString [
	self critical: [ self sourceText replace: aFromIndex to: aToIndex withString: aString ]
]

{ #category : #'api - text' }
GtCoderSourceCode >> resetCollapsedText [
	"Remove the cached collapsed text forcing it to be recomputed next time it is accessed"
	
	collapsedText := nil
]

{ #category : #'api - text' }
GtCoderSourceCode >> resetSourceText [
	"Remove the cached source text forcing it to be recomputed next time it is accessed"

	sourceText := nil
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceString [
	"Return a string representation of the current source text"
	<return: #String>
	
	^ self critical: [ self sourceText asString ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceText [
	<return: #BlText>

	^ self critical: [ sourceText ifNil: [ sourceText := self buildSourceText ] ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceText: aText [
	self critical: [ sourceText := aText copyWithoutExternalReferences ]
]

{ #category : #'api - accessing' }
GtCoderSourceCode >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code if present"

	^ self critical: [ sourceText ifNotNil: [ :aText | aBlock value: aText ] ]
]
