Class {
	#name : #GtCoderNavigationMethodSelected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'method'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationMethodSelected >> method [
	^ method
]

{ #category : #accessing }
GtCoderNavigationMethodSelected >> method: aCompiledMethod [
	method := aCompiledMethod
]
