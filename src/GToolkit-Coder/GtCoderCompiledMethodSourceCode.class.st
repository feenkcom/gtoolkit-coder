"
I represent a source code of a method defined by a class and a selector
"
Class {
	#name : #GtCoderCompiledMethodSourceCode,
	#superclass : #GtCoderSourceCode,
	#instVars : [
		'compiledMethod'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #initialization }
GtCoderCompiledMethodSourceCode >> buildCollapsedText [
	<return: #BlText>

	^ compiledMethod selector asRopedText
]

{ #category : #initialization }
GtCoderCompiledMethodSourceCode >> buildSourceText [
	<return: #BlText>

	^ compiledMethod sourceCode asRopedText
]

{ #category : #accessing }
GtCoderCompiledMethodSourceCode >> compiledMethod [
	^ compiledMethod
]

{ #category : #accessing }
GtCoderCompiledMethodSourceCode >> compiledMethod: aCompiledMethod [
	compiledMethod := aCompiledMethod
]

{ #category : #testing }
GtCoderCompiledMethodSourceCode >> isModified [
	^ compiledMethod sourceCode ~= self sourceString
]
