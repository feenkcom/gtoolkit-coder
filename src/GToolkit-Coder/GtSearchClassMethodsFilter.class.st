Class {
	#name : #GtSearchClassMethodsFilter,
	#superclass : #GtSearchMethodsFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchClassMethodsFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'Class Methods'
		order: 17
		getter: nil
]

{ #category : #comparing }
GtSearchClassMethodsFilter >> = anObject [
	^ self class = anObject class
]

{ #category : #comparing }
GtSearchClassMethodsFilter >> hash [
	^ self class hash
]

{ #category : #testing }
GtSearchClassMethodsFilter >> includesMethod: aCompiledMethod [
	^ aCompiledMethod methodClass isClassSide
]
