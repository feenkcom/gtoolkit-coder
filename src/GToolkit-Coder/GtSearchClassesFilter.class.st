Class {
	#name : #GtSearchClassesFilter,
	#superclass : #GtSearchFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #accessing }
GtSearchClassesFilter >> highlighter [
	^ nil
]

{ #category : #testing }
GtSearchClassesFilter >> includesClass: aClass [
	self subclassResponsibility
]

{ #category : #testing }
GtSearchClassesFilter >> matches: anObject [
	^ self includesClass: anObject
]

{ #category : #accessing }
GtSearchClassesFilter >> resultType [
	^ GtSearchClassGroupResult
]
