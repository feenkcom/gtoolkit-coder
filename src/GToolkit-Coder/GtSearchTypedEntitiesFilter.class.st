Class {
	#name : 'GtSearchTypedEntitiesFilter',
	#superclass : 'GtSearchFilter',
	#category : 'GToolkit-Coder-Filters'
}

{ #category : 'accessing' }
GtSearchTypedEntitiesFilter class >> resultType [
	self subclassResponsibility
]

{ #category : 'accessing' }
GtSearchTypedEntitiesFilter class >> resultTypeStream [
	self subclassResponsibility
]

{ #category : 'accessing' }
GtSearchTypedEntitiesFilter >> resultType [
	^ self class resultType
]

{ #category : 'accessing' }
GtSearchTypedEntitiesFilter >> resultTypeStream [
	^ self class resultTypeStream
]
