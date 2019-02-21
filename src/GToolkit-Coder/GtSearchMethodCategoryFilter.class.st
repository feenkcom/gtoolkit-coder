Class {
	#name : #GtSearchMethodCategoryFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'category'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchMethodCategoryFilter class >> forCategory: aSymbol [
	^ self new
		category: aSymbol;
		yourself
]

{ #category : #accessing }
GtSearchMethodCategoryFilter >> category [
	^ category
]

{ #category : #accessing }
GtSearchMethodCategoryFilter >> category: aSymbol [
	category := aSymbol
]

{ #category : #printing }
GtSearchMethodCategoryFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self category printString;
		nextPutAll: ' method category'
]

{ #category : #testing }
GtSearchMethodCategoryFilter >> includesMethod: aCompiledMethod [
	^ (aCompiledMethod methodClass whichCategoryIncludesSelector: aCompiledMethod selector) = category
]
