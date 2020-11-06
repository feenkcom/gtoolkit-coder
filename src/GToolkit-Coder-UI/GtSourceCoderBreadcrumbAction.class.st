Class {
	#name : #GtSourceCoderBreadcrumbAction,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderBreadcrumbAction >> foreground [
	^ BrGlamorousColors defaultButtonTextColor
]

{ #category : #accessing }
GtSourceCoderBreadcrumbAction >> name [
	<return: #String>

	^ self subclassResponsibility
]

{ #category : #action }
GtSourceCoderBreadcrumbAction >> performSourceCoderActionFrom: anElement [
	self subclassResponsibility
]
