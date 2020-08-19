Class {
	#name : #GtSearchInstanceMethodsFilter,
	#superclass : #GtSearchMethodsFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchInstanceMethodsFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'Instance Methods'
		order: 16
		getter: nil
]

{ #category : #comparing }
GtSearchInstanceMethodsFilter >> = anObject [
	^ self class = anObject class
]

{ #category : #comparing }
GtSearchInstanceMethodsFilter >> hash [
	^ self class hash
]

{ #category : #testing }
GtSearchInstanceMethodsFilter >> includesMethod: aCompiledMethod [
	^ aCompiledMethod methodClass isInstanceSide
]
