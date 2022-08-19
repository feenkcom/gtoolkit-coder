Class {
	#name : #GtCoderNavigationMethodModification,
	#superclass : #GtCoderNavigationSystemChangesAnnouncement,
	#instVars : [
		'method'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationMethodModification >> methodModified [

	^ method
]

{ #category : #accessing }
GtCoderNavigationMethodModification >> methodModified: aMethod [

	method := aMethod
]
