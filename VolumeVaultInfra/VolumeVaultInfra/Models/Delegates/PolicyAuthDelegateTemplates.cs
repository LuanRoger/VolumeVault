using Microsoft.AspNetCore.Authorization;

namespace VolumeVaultInfra.Models.Delegates;

internal static class PolicyAuthDelegateTemplates
{
    internal static void JWTRequiredIdClaimPolicy(AuthorizationPolicyBuilder policyBuilder)
    {
        policyBuilder.RequireClaim("ID");
    }
}