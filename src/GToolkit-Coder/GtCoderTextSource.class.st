"
I represent a source code of the {{gtClass:GtTextualCoder}}. For performance reasons the computation of the actual source code in the coder is done lazily. I am to provide a necessary abstraction to support it
"
Class {
	#name : #GtCoderTextSource,
	#superclass : #Object,
	#instVars : [
		'monitor',
		'originalSourceTextPromise',
		'currentSourceText'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #'api - converting' }
GtCoderTextSource >> asCompiledMethodSourceCode: aCompiledMethod [
	^ (GtCoderCompiledMethodTextSource new fromSourceCode: self) compiledMethod: aCompiledMethod
]

{ #category : #'mutual exclusion' }
GtCoderTextSource >> critical: aBlock [
	^ monitor critical: aBlock
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceString [
	"Return a string representation of the current source text"
	<return: #TAsyncPromise of: #GtCoderSourceString>
	
	^ self critical: [ self currentSourceText then: [ :aGtCoderSourceText | aGtCoderSourceText asSourceString ] ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceString: aString [
	"Set a new source text"

	self critical: [ currentSourceText := GtCoderSourceText new text: aString asRopedText ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceText [
	<return: #TAsyncPromise of: #GtCoderSourceText>

	^ self critical: [
		currentSourceText
			ifNotNil: [ :aSourceText | aSourceText asAsyncPromise ]
			ifNil: [ self originalSourceTextPromise ] ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceText: aText [
	"Set a new source text"

	self critical: [ 
		currentSourceText := GtCoderSourceText new 
			text: aText copyWithoutExternalReferences ]
]

{ #category : #initialization }
GtCoderTextSource >> fromSourceCode: aGtCoderTextSource [
	originalSourceTextPromise := aGtCoderTextSource privateGetOriginalSourceTextPromise.
	currentSourceText := aGtCoderTextSource privateGetCurrentSourceText
]

{ #category : #'api - testing' }
GtCoderTextSource >> hasSourceText [
	<return: #Boolean>

	^ self critical: [ originalSourceTextPromise notNil ]
]

{ #category : #initialization }
GtCoderTextSource >> initialize [
	super initialize.
	
	monitor := Monitor new.
	currentSourceText := nil.
	originalSourceTextPromise := nil
]

{ #category : #'api - testing' }
GtCoderTextSource >> isModified [
	^ self isModifiedPromise wait
]

{ #category : #'api - testing' }
GtCoderTextSource >> isModifiedPromise [
	currentSourceText
		ifNil: [ ^ false asAsyncPromise ].
	
	^ self originalSourceTextPromise then: [ :anOriginalSourceText | self currentSourceText then: [ :aCurrentSourceText | anOriginalSourceText text characters ~= aCurrentSourceText text characters ] ]
]

{ #category : #initialization }
GtCoderTextSource >> originalSourceTextFuture [
	<return: #TAsyncFuture>

	^ self subclassResponsibility
]

{ #category : #initialization }
GtCoderTextSource >> originalSourceTextPromise [

	<return: #TAsyncPromise>
	^ self critical: [ 
		  originalSourceTextPromise ifNil: [ 
			  originalSourceTextPromise := (
			  	self originalSourceTextFuture map: [ :aText | 
				  	GtCoderSourceText new text: aText ]) asAsyncPromise ] ]
]

{ #category : #'private - accessing' }
GtCoderTextSource >> privateGetCurrentSourceText [
	^ currentSourceText
]

{ #category : #'private - accessing' }
GtCoderTextSource >> privateGetOriginalSourceTextPromise [
	^ originalSourceTextPromise
]

{ #category : #'api - accessing' }
GtCoderTextSource >> resetSourceText [
	"Remove the cached source text forcing it to be recomputed next time it is accessed"
	
	self critical: [
		originalSourceTextPromise := nil.
		currentSourceText := nil ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> sourceString [
	"Return a string representation of the current source text"
	<return: #TAsyncPromise>
	
	self
		deprecated: 'Use #currentSourceString'
		transformWith: '`@receiver sourceString' -> '`@receiver currentSourceString'.

	^ self currentSourceString
]

{ #category : #'api - accessing' }
GtCoderTextSource >> sourceText [
	<return: #TAsyncPromise>

	self
		deprecated: 'Use #currentSourceText'
		transformWith: '`@receiver sourceText' -> '`@receiver currentSourceText'.

	^ self currentSourceText
]
