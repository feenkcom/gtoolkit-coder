"
I define actions that should appear in navigation method list, next to each method label.
"
Class {
	#name : #GtCoderNavigationMethodTarget,
	#superclass : #GtPhlowActionUniqueTarget,
	#classVars : [
		'IsEnabled'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #accessing }
GtCoderNavigationMethodTarget class >> disable [
	^ IsEnabled := false
]

{ #category : #accessing }
GtCoderNavigationMethodTarget class >> enable [
	^ IsEnabled := true
]

{ #category : #accessing }
GtCoderNavigationMethodTarget class >> isEnabled [
	^ IsEnabled ifNil: [ IsEnabled := false ]
]
