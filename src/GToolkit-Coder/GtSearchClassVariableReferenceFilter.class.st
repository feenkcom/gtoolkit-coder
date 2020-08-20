Class {
	#name : #GtSearchClassVariableReferenceFilter,
	#superclass : #GtSearchReferencesFilter,
	#instVars : [
		'class',
		'variableName'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchClassVariableReferenceFilter class >> createFilterFor: aMethodCoder [
	^ self forClass: aMethodCoder classOrMetaClass
]

{ #category : #accessing }
GtSearchClassVariableReferenceFilter class >> filterDescriptorFor: aMethodsCoder [
	aMethodsCoder isForClass
		ifFalse: [ ^ nil ].
	^ GtFilterDescriptor
		forClass: self
		named: 'ClassVar'
		order: 25
		getter: #variableName
		setter: #variableName:
		completion:
			(GtStringsCompletionStrategy new
				completions:
					(GtPrefixTree withAll: aMethodsCoder classOrMetaClass allClassVarNames))
]

{ #category : #'instance creation' }
GtSearchClassVariableReferenceFilter class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #'instance creation' }
GtSearchClassVariableReferenceFilter class >> forClass: aClass andVariable: aString [
	^ (self forClass: aClass)
		variableName: aString;
		yourself
]

{ #category : #'initialize-release' }
GtSearchClassVariableReferenceFilter >> forClass: aClass [
	class := aClass
]

{ #category : #testing }
GtSearchClassVariableReferenceFilter >> includesMethod: aCompiledMethod [
	self object isNil
		ifTrue: [ ^ false ].
	^ super includesMethod: aCompiledMethod
]

{ #category : #accessing }
GtSearchClassVariableReferenceFilter >> object [
	^ object ifNil: [ object := class bindingOf: variableName ]
]

{ #category : #accessing }
GtSearchClassVariableReferenceFilter >> variableName [
	^ variableName
]

{ #category : #accessing }
GtSearchClassVariableReferenceFilter >> variableName: aSymbol [
	variableName := aSymbol asSymbol.
	object := nil
]
