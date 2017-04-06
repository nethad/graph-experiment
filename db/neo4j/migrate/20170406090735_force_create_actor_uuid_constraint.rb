class ForceCreateActorUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Actor, :uuid, force: true
  end

  def down
    drop_constraint :Actor, :uuid
  end
end
