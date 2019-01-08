Class {
	#name : #GtCoderMethodCategoryFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'category'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderMethodCategoryFilter class >> forCategory: aSymbol [
	^ self new
		category: aSymbol;
		yourself
]

{ #category : #accessing }
GtCoderMethodCategoryFilter >> category [
	^ category
]

{ #category : #accessing }
GtCoderMethodCategoryFilter >> category: aSymbol [
	category := aSymbol
]

{ #category : #printing }
GtCoderMethodCategoryFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self category printString;
		nextPutAll: ' method category'
]

{ #category : #testing }
GtCoderMethodCategoryFilter >> includeMethod: aCompiledMethod [
	^ (aCompiledMethod methodClass whichCategoryIncludesSelector: aCompiledMethod selector) = category
]
