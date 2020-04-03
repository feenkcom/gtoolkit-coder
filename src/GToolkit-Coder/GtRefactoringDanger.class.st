Class {
	#name : #GtRefactoringDanger,
	#superclass : #Object,
	#instVars : [
		'condition',
		'description'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #accessing }
GtRefactoringDanger >> condition [
	^ condition
]

{ #category : #accessing }
GtRefactoringDanger >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
GtRefactoringDanger >> description [
	^ description
]

{ #category : #accessing }
GtRefactoringDanger >> description: anObject [
	description := anObject
]
