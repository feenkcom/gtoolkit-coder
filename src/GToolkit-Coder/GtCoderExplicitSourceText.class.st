Class {
	#name : 'GtCoderExplicitSourceText',
	#superclass : 'GtCoderSourceCode',
	#instVars : [
		'text'
	],
	#category : 'GToolkit-Coder-Coders'
}

{ #category : 'api - accessing' }
GtCoderExplicitSourceText >> asAstCacheKey [
	^ text
]

{ #category : 'initialization' }
GtCoderExplicitSourceText >> buildCollapsedText [
	<return: #BlText>

	^ (self sourceString linesDo: [ :eachLine | eachLine trimmed ifNotEmpty: [ :aNonEmptyLine | ^ aNonEmptyLine ] ]) asRopedText
]

{ #category : 'initialization' }
GtCoderExplicitSourceText >> buildSourceText [
	<return: #BlText>

	^ text copy
]

{ #category : 'api - testing' }
GtCoderExplicitSourceText >> isModified [
	^ self text rope ~= self sourceText rope
]

{ #category : 'accessing' }
GtCoderExplicitSourceText >> text [
	^ text
]

{ #category : 'accessing' }
GtCoderExplicitSourceText >> text: aStringOrText [
	text := aStringOrText asRopedText
]
