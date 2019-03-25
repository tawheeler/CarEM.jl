"""
    LaneFollowingAccel
Longitudinal acceleration
"""
struct LaneFollowingAccel
    a::Float64
end

function propagate(veh::Vehicle1D, action::LaneFollowingAccel, roadway::StraightRoadway, Δt::Float64)

    a = action.a
    s, v = veh.state.s, veh.state.v

    s′ = s + v*Δt + a*Δt*Δt/2
    v′ = v + a*Δt

    s′ = mod_position_to_roadway(s′, roadway)

    return State1D(s′, v′)
end

function propagate(veh::Vehicle, action::LaneFollowingAccel, roadway::Roadway, ΔT::Float64)

    a_lon = action.a

    ds = veh.state.v

    ΔT² = ΔT*ΔT
    Δs = ds*ΔT + 0.5*a_lon*ΔT²

    v₂ = ds + a_lon*ΔT

    roadind = move_along(veh.state.posF.roadind, roadway, Δs)
    posG = roadway[roadind].pos
    VehicleState(posG, roadway, v₂)
end


#XXX these should probably be removed
# Base.show(io::IO, a::LaneFollowingAccel) = @printf(io, "LaneFollowingAccel(%6.3f)", a.a)
# Base.length(::Type{LaneFollowingAccel}) = 1
# Base.convert(::Type{LaneFollowingAccel}, v::Vector{Float64}) = LaneFollowingAccel(v[1])

# function Base.copyto!(v::Vector{Float64}, a::LaneFollowingAccel)
#     v[1] = a.a
#     v
# end