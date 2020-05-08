Class {
	#name : #GtCoderNavigationMethodSelected,
	#superclass : #GtCoderNavigationAnnouncement,
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
GtCoderNavigationMethodSelected >> method: aMethod [
	method := aMethod
]
