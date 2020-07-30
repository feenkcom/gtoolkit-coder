Class {
	#name : #GtSearchMethodCategoryFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'category'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchMethodCategoryFilter class >> filterDescriptorFor: aMethodCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'Category'
		order: 15
		getter: #category
]

{ #category : #'instance creation' }
GtSearchMethodCategoryFilter class >> forCategory: aSymbol [
	^ self new
		category: aSymbol;
		yourself
]

{ #category : #comparing }
GtSearchMethodCategoryFilter >> = anObject [
	^ self class = anObject class
		and: [ self category = anObject category ]
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

{ #category : #comparing }
GtSearchMethodCategoryFilter >> hash [
	^ self class hash bitXor: self category hash
]

{ #category : #testing }
GtSearchMethodCategoryFilter >> includesMethod: aCompiledMethod [
	^ (aCompiledMethod methodClass whichCategoryIncludesSelector: aCompiledMethod selector) = category
]
