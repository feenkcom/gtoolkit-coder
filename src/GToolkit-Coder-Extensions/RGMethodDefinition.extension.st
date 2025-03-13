Extension { #name : #RGMethodDefinition }

{ #category : #'*GToolkit-Coder-Extensions' }
RGMethodDefinition >> gtLocalVersionsFor: aView [
	<gtView>
	
	self isDefined ifFalse: [ ^aView empty].
	
	^aView forward 
		title: 'Local versions';
		object: [ self compiledMethod ];
		priority: 10;
		view: #gtLocalVersionsFor:
]
