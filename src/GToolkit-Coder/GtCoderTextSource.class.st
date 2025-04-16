"
I represent a source code of the {{gtClass:GtTextualCoder}}. For performance reasons the computation of the actual source code in the coder is done lazily. I am to provide a necessary abstraction to support it
"
Class {
	#name : #GtCoderTextSource,
	#superclass : #Object,
	#instVars : [
		'monitor',
		'currentSourceText',
		'originalSourceText'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #'api - converting' }
GtCoderTextSource >> asCompiledMethodSourceCode: aCompiledMethod [
	^ (GtCoderCompiledMethodTextSource new fromSourceCode: self) compiledMethod: aCompiledMethod
]

{ #category : #initialization }
GtCoderTextSource >> computeOriginalSourceText [
	^ self subclassResponsibility
]

{ #category : #'mutual exclusion' }
GtCoderTextSource >> critical: aBlock [
	^ monitor critical: aBlock
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceString [
	"Return a string representation of the current source text"
	<return: #GtCoderSourceString>

	^ self critical: [ self currentSourceText asSourceString ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceString: aString [
	"Set a new source text"

	self critical: [ currentSourceText := GtCoderSourceText new
		text: aString asRopedText;
		yourself ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceText [
	<return: #GtCoderSourceText>

	^ self critical: [ currentSourceText ifNil: [ self originalSourceText ] ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> currentSourceText: aText [
	"Set a new source text"

	self critical: [ 
		currentSourceText := GtCoderSourceText new 
			text: aText copyWithoutExternalReferences;
			yourself ]
]

{ #category : #initialization }
GtCoderTextSource >> fromSourceCode: aGtCoderTextSource [
	originalSourceText := aGtCoderTextSource privateGetOriginalSourceText.
	currentSourceText := aGtCoderTextSource privateGetCurrentSourceText
]

{ #category : #'api - testing' }
GtCoderTextSource >> hasSourceText [
	<return: #Boolean>

	^ originalSourceText notNil
]

{ #category : #initialization }
GtCoderTextSource >> initialize [
	super initialize.
	
	monitor := Mutex new.
	currentSourceText := nil.
	originalSourceText := nil
]

{ #category : #'api - testing' }
GtCoderTextSource >> isModified [
	^ self critical: [
		currentSourceText
			ifNil: [ ^ false ].
		self originalSourceText text characters ~= self currentSourceText text characters ]
]

{ #category : #'api - accessing' }
GtCoderTextSource >> originalSourceText [
	^ self
		critical: [ originalSourceText
				ifNil: [ originalSourceText := GtCoderSourceText new
							text: self computeOriginalSourceText ] ]
]

{ #category : #'private - accessing' }
GtCoderTextSource >> privateGetCurrentSourceText [
	^ currentSourceText
]

{ #category : #'private - accessing' }
GtCoderTextSource >> privateGetOriginalSourceText [
	^ originalSourceText
]

{ #category : #'api - accessing' }
GtCoderTextSource >> resetSourceText [
	"Remove the cached source text forcing it to be recomputed next time it is accessed"
	
	self critical: [
		originalSourceText := nil.
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
