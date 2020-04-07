Class {
	#name : #GtBehaviorCoderHeaderModel,
	#superclass : #BrWidgetModel,
	#instVars : [
		'definition',
		'behavior'
	],
	#category : #'GToolkit-Coder-Behavior - UI'
}

{ #category : #'api - behavior' }
GtBehaviorCoderHeaderModel >> behavior [
	<return: #Behavior>

	^ behavior
]

{ #category : #initialization }
GtBehaviorCoderHeaderModel >> behavior: aBehavior [
	behavior := aBehavior.
	
	definition := self definitionFrom: aBehavior.
	
	self notifyBehaviorChanged: aBehavior
]

{ #category : #'api - behavior' }
GtBehaviorCoderHeaderModel >> behaviorName [
	<return: #String>
	
	^ self behavior name
]

{ #category : #accessing }
GtBehaviorCoderHeaderModel >> definition [
	<return: #GtCodeDefinition>

	^ definition
]

{ #category : #initialization }
GtBehaviorCoderHeaderModel >> definitionFrom: aBehavior [
	^ GtBehaviorDefinition fromBehavior: aBehavior
]

{ #category : #'api - behavior' }
GtBehaviorCoderHeaderModel >> difference [
	<return: #GtCodeDefinitionDifference>
	
	^ self definition differenceWith: (self definitionFrom: self behavior)
]

{ #category : #accessing }
GtBehaviorCoderHeaderModel >> editors [
	<return: #Collection of: #GtCodeDefinitionEditor>
	
	^ self definition editors
]

{ #category : #initialization }
GtBehaviorCoderHeaderModel >> initialize [
	super initialize.
	
	self behavior: Class new
]

{ #category : #'private - notifying' }
GtBehaviorCoderHeaderModel >> notifyBehaviorChanged: aBehavior [
	self dispatchEvent: (GtBehaviorCoderHeaderClassChanged new theClass: aBehavior)
]

{ #category : #'api - behavior' }
GtBehaviorCoderHeaderModel >> refactorings [	
	^  self definition difference: self difference toRefactoringsOf: self behavior
]

{ #category : #'api - behavior' }
GtBehaviorCoderHeaderModel >> refactoringsIn: anRBModel [
	^  self definition difference: self difference toRefactoringsOf: self behavior in: anRBModel
]

{ #category : #accessing }
GtBehaviorCoderHeaderModel >> theClass [
	self deprecated: 'Use #behavior instead'.
	
	^ self behavior
]

{ #category : #accessing }
GtBehaviorCoderHeaderModel >> theClass: aBehavior [
	self deprecated: 'Use #behavior: instead'.
	
	self behavior: aBehavior
]

{ #category : #accessing }
GtBehaviorCoderHeaderModel >> theClassName [
	self deprecated: 'Use #behaviorName instead'.
	
	^ self behaviorName
]
