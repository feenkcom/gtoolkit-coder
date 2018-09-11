Class {
	#name : #BaselineOfGToolkitCoder,
	#superclass : #BaselineOf,
	#category : 'BaselineOfGToolkitCoder'
}

{ #category : #baseline }
BaselineOfGToolkitCoder >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec 
				baseline: 'Brick' with: [ 
					spec repository: 'github://pharo-graphics/Brick/src' ];			
				package: 'GToolkit-Coder' with: [ 
					spec requires: #( 'Brick') ];
				package: 'GToolkit-Coder-Examples' with: [ 
					spec requires: #( 'GToolkit-Coder' ) ] ]
]
